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
          query_params :search
          safe_attributes :search
          permit_resource true
        end

        class Show < AStream::BaseAction
          query_by('users#search') { |r| { piped: 'search_response' } }
          query_params :piped
          safe_attributes :show
          permit_resource true
        end

        class Approve < AStream::BaseAction
          query_by('users#show') { |r| { piped: 'show_response' } }
          query_params :piped
          safe_attributes :approve
          permit_resource true
        end

        class Reject < AStream::BaseAction
          query_by('users#show') { |r| { piped: 'show_response' } }
          query_params :piped
          safe_attributes :reject
          permit_resource true
        end

        class Delete < AStream::BaseAction
          query_by('users#show') { |r| { piped: 'show_response' } }
          query_params :piped
          safe_attributes :delete
          permit_resource true
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

      context 'successful responses' do
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
          expect(AStream::ActionStreamsRunner.run(performer, action_streams)).to eq({
            search_users: {body: [search: 'response']},
            show_users: {body: [show: 'response']},
            approve_users: {body: [approve: 'response']},
            reject_users: {body: [reject: 'response']},
            delete_users: {body: [delete: 'response']}
          })
        end
      end

      context 'search request unsuccessful' do
        specify do
          expect(search).to receive(:perform_read).with(performer, search: 'query').and_return(status: :unathorized, body: []).once

          expect(show).not_to receive(:pipe_data_from).with(search, [search: 'response'])
          expect(show).not_to receive(:perform_read).with(performer, piped: 'search_response')

          expect(approve).not_to receive(:pipe_data_from).with(show, [show: 'response'])
          expect(approve).not_to receive(:perform_read).with(performer, piped: 'show_response')

          expect(reject).not_to receive(:pipe_data_from).with(show, [show: 'response'])
          expect(reject).not_to receive(:perform_read).with(performer, piped: 'show_response')

          expect(delete).not_to receive(:pipe_data_from).with(show, [show: 'response'])
          expect(delete).not_to receive(:perform_read).with(performer, piped: 'show_response')
        end

        after do
          expect(AStream::ActionStreamsRunner.run(performer, action_streams)).to eq({
            search_users: {status: :unathorized, body: []}
          })
        end
      end

      context 'show request unsuccessful' do
        specify do
          expect(search).to receive(:perform_read).with(performer, search: 'query').and_return([search: 'response']).once.ordered

          expect(show).to receive(:pipe_data_from).with(search, [search: 'response']).and_return(piped: 'search_response').once.ordered
          expect(show).to receive(:perform_read).with(performer, piped: 'search_response').and_return(status: :unprocessable_entity, body: []).once.ordered

          expect(approve).not_to receive(:pipe_data_from).with(show, [show: 'response'])
          expect(approve).not_to receive(:perform_read).with(performer, piped: 'show_response')

          expect(reject).not_to receive(:pipe_data_from).with(show, [show: 'response'])
          expect(reject).not_to receive(:perform_read).with(performer, piped: 'show_response')

          expect(delete).not_to receive(:pipe_data_from).with(show, [show: 'response'])
          expect(delete).not_to receive(:perform_read).with(performer, piped: 'show_response')
        end

        after do
          expect(AStream::ActionStreamsRunner.run(performer, action_streams)).to eq({
            search_users: {body: [search: 'response']},
            show_users: {status: :unprocessable_entity, body: []}
          })
        end
      end

      context 'approve request unsuccessful' do
        specify do
          expect(search).to receive(:perform_read).with(performer, search: 'query').and_return([search: 'response']).once.ordered

          expect(show).to receive(:pipe_data_from).with(search, [search: 'response']).and_return(piped: 'search_response').once.ordered
          expect(show).to receive(:perform_read).with(performer, piped: 'search_response').and_return([show: 'response']).once.ordered

          expect(approve).to receive(:pipe_data_from).with(show, [show: 'response']).and_return(piped: 'show_response').once.ordered
          expect(approve).to receive(:perform_read).with(performer, piped: 'show_response').and_return(status: :not_found, body: []).once.ordered

          expect(reject).to receive(:pipe_data_from).with(show, [show: 'response']).and_return(piped: 'show_response').once.ordered
          expect(reject).to receive(:perform_read).with(performer, piped: 'show_response').and_return([reject: 'response']).once.ordered

          expect(delete).to receive(:pipe_data_from).with(show, [show: 'response']).and_return(piped: 'show_response').once.ordered
          expect(delete).to receive(:perform_read).with(performer, piped: 'show_response').and_return([delete: 'response']).once.ordered
        end

        after do
          expect(AStream::ActionStreamsRunner.run(performer, action_streams)).to eq({
            search_users: {body: [search: 'response']},
            show_users: {body: [show: 'response']},
            approve_users: {status: :not_found, body: []},
            reject_users: {body: [reject: 'response']},
            delete_users: {body: [delete: 'response']}
          })
        end
      end
    end
  end
end
