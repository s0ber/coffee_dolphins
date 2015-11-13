require 'rails_helper'
require 'support/shared_examples/action_classes_definition'

describe AStream::ActionStreamsRunner do
  after do
    %w(Search Show Approve Reject Delete).each do |a|
      Actions::Users.send :remove_const, a.to_sym
    end
  end

  before do
    module Actions
      module Users
        class Search < AStream::BaseAction
          def self.query_attributes; [:search] end
          def self.perform_read(performer, query); end
          def self.safe_attributes(performer); [:search] end
          def self.permit(performer, item); true end
        end

        class Show < AStream::BaseAction
          query_by('users#search') { |r| { piped: 'search_response' } }
          def self.query_attributes; [:piped] end
          def self.perform_read(performer, query); end
          def self.safe_attributes(performer); [:show] end
          def self.permit(performer, item); true end
        end

        class Approve < AStream::BaseAction
          query_by('users#show') { |r| { piped: 'show_response' } }
          def self.query_attributes; [:piped] end
          def self.perform_read(performer, query); end
          def self.safe_attributes(performer); [:approve] end
          def self.permit(performer, item); true end
        end

        class Reject < AStream::BaseAction
          query_by('users#show') { |r| { piped: 'show_response' } }
          def self.query_attributes; [:piped] end
          def self.perform_read(performer, query); end
          def self.safe_attributes(performer); [:reject] end
          def self.permit(performer, item); true end
        end

        class Delete < AStream::BaseAction
          query_by('users#show') { |r| { piped: 'show_response' } }
          def self.query_attributes; [:piped] end
          def self.perform_read(performer, query); end
          def self.safe_attributes(performer); [:delete] end
          def self.permit(performer, item); true end
        end
      end
    end
  end

  let(:search) { Actions::Users::Search }
  let(:show) { Actions::Users::Show }
  let(:approve) { Actions::Users::Approve }
  let(:reject) { Actions::Users::Reject }
  let(:delete) { Actions::Users::Delete }
  let(:performer) { create(:user) }

  before do
    allow(search).to receive(:perform_read).and_return([search: 'response'])
    allow(show).to receive(:perform_read).and_return([show: 'response'])
    allow(approve).to receive(:perform_read).and_return([approve: 'response'])
    allow(reject).to receive(:perform_read).and_return([reject: 'response'])
    allow(delete).to receive(:perform_read).and_return([delete: 'response'])
  end

  describe '.run' do
    context 'action streams tree given' do
      let(:action_streams) do
        [
          AStream::ActionRequest.new(runner: search, performer: performer, query: {search: 'query'}, pipe: [
            AStream::ActionRequest.new(runner: show, performer: performer, pipe: [
              AStream::ActionRequest.new(runner: approve, performer: performer),
              AStream::ActionRequest.new(runner: reject, performer: performer),
              AStream::ActionRequest.new(runner: delete, performer: performer)
            ])
          ])
        ]
      end

      specify do
        expect(search).to receive(:perform_read).with(performer, search: 'query').and_return([search: 'response']).once.ordered

        expect(show).to receive(:pipe_data_from).with(search, [search: 'response']).and_return(piped: 'search_response').once.ordered
        expect(show).to receive(:perform_read).with(performer, piped: 'search_response').and_return([show: 'response']).once.ordered

        expect(approve).to receive(:pipe_data_from).with(show, [show: 'response']).and_return(piped: 'show_response').once.ordered
        expect(approve).to receive(:perform_read).with(performer, piped: 'show_response').and_return([approve: 'response']).once.ordered

        expect(reject).to receive(:pipe_data_from).with(show, [show: 'response']).and_return(piped: 'show_response').once.ordered
        expect(reject).to receive(:perform_read).with(performer, piped: 'show_response').and_return([reject: 'response']).once.ordered

        expect(delete).to receive(:pipe_data_from).with(show, [show: 'response']).and_return(piped: 'show_response').once.ordered
        expect(delete).to receive(:perform_read).with(performer, piped: 'show_response').and_return([delete: 'response']).once.ordered
      end

      after do
        AStream::ActionStreamsRunner.run(performer, action_streams)
      end
    end
  end
end
