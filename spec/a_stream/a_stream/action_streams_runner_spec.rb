require 'rails_helper'
require 'support/shared_examples/action_classes_definition'

describe AStream::ActionStreamsRunner do
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
        def perform_read(performer, query)
          [search: 'response']
        end
      end

      class Show < AStream::BaseAction
        query_by('users#search') { |r| { piped: 'search_response' } }
        query_params :piped
        safe_attributes :show
        permit_resource true
        def perform_read(performer, query)
          [show: 'response']
        end
      end

      class Approve < AStream::BaseAction
        query_by('users#show') { |r| { piped: 'show_response' } }
        query_params :piped, :approve
        safe_attributes :approve
        permit_resource true
        def perform_read(performer, query)
          [approve: 'response']
        end

        def perform_update(performer, query)
          [approve: 'update_response']
        end
      end

      class Reject < AStream::BaseAction
        query_by('users#show') { |r| { piped: 'show_response' } }
        query_params :piped
        safe_attributes :reject
        permit_resource true
        def perform_read(performer, query)
          [reject: 'response']
        end
      end

      class Delete < AStream::BaseAction
        query_by('users#show') { |r| { piped: 'show_response' } }
        query_params :piped
        safe_attributes :delete
        permit_resource true
        def perform_read(performer, query)
          [delete: 'response']
        end
      end
    end
  end

  let(:search) { Users::Search }
  let(:show) { Users::Show }
  let(:approve) { Users::Approve }
  let(:reject) { Users::Reject }
  let(:delete) { Users::Delete }

  let(:performer) { create(:user) }
  let(:controller) { double('fake controller') }

  describe '#run' do
    subject { AStream::ActionStreamsRunner.new(performer: performer, controller: controller) }

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
          expect(show).to receive(:pipe_data_from).with(search, [search: 'response']).and_return(piped: 'search_response').once.ordered
          expect(approve).to receive(:pipe_data_from).with(show, [show: 'response']).and_return(piped: 'show_response').once.ordered
          expect(reject).to receive(:pipe_data_from).with(show, [show: 'response']).and_return(piped: 'show_response').once.ordered
          expect(delete).to receive(:pipe_data_from).with(show, [show: 'response']).and_return(piped: 'show_response').once.ordered
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
        before do
          Users::Search.class_eval do
            def perform_read(performer, query)
              AStream::Response.new(status: :unauthorized)
            end
          end
        end

        specify do
          expect(show).not_to receive(:pipe_data_from).with(search, [search: 'response'])
          expect(approve).not_to receive(:pipe_data_from).with(show, [show: 'response'])
          expect(reject).not_to receive(:pipe_data_from).with(show, [show: 'response'])
          expect(delete).not_to receive(:pipe_data_from).with(show, [show: 'response'])
        end

        after do
          expect(subject.run(action_streams)).to eq({
            users_search: {status: :unauthorized, body: nil}
          })
        end
      end

      context 'show request unsuccessful' do
        before do
          Users::Show.class_eval do
            def perform_read(performer, query)
              AStream::Response.new(status: :unprocessable_entity)
            end
          end
        end

        specify do
          expect(show).to receive(:pipe_data_from).with(search, [search: 'response']).and_return(piped: 'search_response').once.ordered
          expect(approve).not_to receive(:pipe_data_from).with(show, [show: 'response'])
          expect(reject).not_to receive(:pipe_data_from).with(show, [show: 'response'])
          expect(delete).not_to receive(:pipe_data_from).with(show, [show: 'response'])
        end

        after do
          expect(subject.run(action_streams)).to eq({
            users_search: {body: [search: 'response']},
            users_show: {status: :unprocessable_entity, body: nil}
          })
        end
      end

      context 'approve request unsuccessful' do
        before do
          Users::Approve.class_eval do
            def perform_read(performer, query)
              AStream::Response.new(status: :not_found)
            end
          end
        end

        specify do
          expect(show).to receive(:pipe_data_from).with(search, [search: 'response']).and_return(piped: 'search_response').once.ordered
          expect(approve).to receive(:pipe_data_from).with(show, [show: 'response']).and_return(piped: 'show_response').once.ordered
          expect(reject).to receive(:pipe_data_from).with(show, [show: 'response']).and_return(piped: 'show_response').once.ordered
          expect(delete).to receive(:pipe_data_from).with(show, [show: 'response']).and_return(piped: 'show_response').once.ordered
        end

        after do
          expect(subject.run(action_streams)).to eq({
            users_search: {body: [search: 'response']},
            users_show: {body: [show: 'response']},
            users_approve: {status: :not_found, body: nil},
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
          expect(search).to receive(:pipe_data_from).with(approve, [approve: 'update_response']).and_return(piped: 'search_response').once.ordered
          expect(show).to receive(:pipe_data_from).with(search, [search: 'response']).and_return(piped: 'search_response').once.ordered
        end

        after do
          expect(subject.run(action_streams)).to eq({
            users_approve: {body: [approve: 'update_response']},
            users_search: {body: [search: 'response']},
            users_show: {body: [show: 'response']}
          })
        end
      end

      context 'unsuccessful response' do
        before do
          Users::Approve.class_eval do
            def perform_update(performer, query)
              AStream::Response.new(status: :unauthorized)
            end
          end
        end

        specify do
          expect(search).not_to receive(:pipe_data_from).with(approve, [approve: 'update_response'])
          expect(show).not_to receive(:pipe_data_from).with(search, [search: 'response'])
        end

        after do
          expect(subject.run(action_streams)).to eq({
            users_approve: {status: :unauthorized, body: nil}
          })
        end
      end
    end
  end
end
