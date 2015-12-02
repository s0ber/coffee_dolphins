require 'rails_helper'
require 'support/shared_examples/action_classes_definition'

describe AStream::ActionStreamsRunner do
  subject { AStream::ActionStreamsRunner.new(performer: performer) }

  after do
    %w(Search Show Approve Reject Delete).each do |a|
      Users.send :remove_const, a.to_sym
    end
  end

  before do
    module Users
      class Search < AStream::BaseAction
        query_by('users#approve') { |r| { piped: 'search_response' } }
        query_params :search, :piped
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
        query_params :piped, :approve
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

  let(:search) { Users::Search }
  let(:show) { Users::Show }
  let(:approve) { Users::Approve }
  let(:reject) { Users::Reject }
  let(:delete) { Users::Delete }
  let(:performer) { create(:user) }

  describe '.run' do
    context 'action streams tree with initial get request given' do
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
          expect(subject.run(action_streams)).to eq({
            users_search: {body: [search: 'response']},
            users_show: {body: [show: 'response']},
            users_approve: {body: [approve: 'response']},
            users_reject: {body: [reject: 'response']},
            users_delete: {body: [delete: 'response']}
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
          expect(subject.run(action_streams)).to eq({
            users_search: {status: :unathorized, body: []}
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
          expect(subject.run(action_streams)).to eq({
            users_search: {body: [search: 'response']},
            users_show: {status: :unprocessable_entity, body: []}
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
          expect(subject.run(action_streams)).to eq({
            users_search: {body: [search: 'response']},
            users_show: {body: [show: 'response']},
            users_approve: {status: :not_found, body: []},
            users_reject: {body: [reject: 'response']},
            users_delete: {body: [delete: 'response']}
          })
        end
      end
    end

    context 'action streams tree with initial post request given' do
      let(:action_streams) do
        [
          AStream::ActionRequest.new(runner: approve, type: :post, performer: performer, query: {approve: 'query'}, pipe: [
            AStream::ActionRequest.new(runner: search, performer: performer, pipe: [
              AStream::ActionRequest.new(runner: show, performer: performer)
            ])
          ])
        ]
      end

      context 'successful responses' do
        specify do
          expect(approve).to receive(:perform_read).with(performer, approve: 'query').and_return([approve: 'read_response']).once.ordered
          expect(approve).to receive(:perform_update).with(performer, approve: 'query').and_return([approve: 'update_response']).once.ordered

          expect(search).to receive(:pipe_data_from).with(approve, [approve: 'update_response']).and_return(piped: 'search_response').once.ordered
          expect(search).to receive(:perform_read).with(performer, piped: 'search_response').and_return([search: 'response']).once.ordered

          expect(show).to receive(:pipe_data_from).with(search, [search: 'response']).and_return(piped: 'search_response').once.ordered
          expect(show).to receive(:perform_read).with(performer, piped: 'search_response').and_return([show: 'response']).once.ordered
        end

        after do
          expect(subject.run(action_streams)).to eq({
            users_approve: {body: [approve: 'update_response']},
            users_search: {body: [search: 'response']},
            users_show: {body: [show: 'response']}
          })
        end
      end

      context 'read response unsuccessful' do
        specify do
          expect(approve).to receive(:perform_read).with(performer, approve: 'query').and_return(status: :unprocessable_entity, body: []).once.ordered
          expect(approve).not_to receive(:perform_update).with(performer, approve: 'query')

          expect(search).not_to receive(:pipe_data_from).with(approve, [approve: 'update_response'])
          expect(search).not_to receive(:perform_read).with(performer, piped: 'search_response')

          expect(show).not_to receive(:pipe_data_from).with(search, [search: 'response'])
          expect(show).not_to receive(:perform_read).with(performer, piped: 'search_response')
        end

        after do
          expect(subject.run(action_streams)).to eq({
            users_approve: {status: :unprocessable_entity, body: []}
          })
        end
      end

      context 'update response unsuccessful' do
        specify do
          expect(approve).to receive(:perform_read).with(performer, approve: 'query').and_return([approve: 'read_response']).once.ordered
          expect(approve).to receive(:perform_update).with(performer, approve: 'query').and_return(status: :unathorized).once.ordered

          expect(search).not_to receive(:pipe_data_from).with(approve, [approve: 'update_response'])
          expect(search).not_to receive(:perform_read).with(performer, piped: 'search_response')

          expect(show).not_to receive(:pipe_data_from).with(search, [search: 'response'])
          expect(show).not_to receive(:perform_read).with(performer, piped: 'search_response')
        end

        after do
          expect(subject.run(action_streams)).to eq({
            users_approve: {status: :unathorized, body: []}
          })
        end
      end
    end
  end
end
