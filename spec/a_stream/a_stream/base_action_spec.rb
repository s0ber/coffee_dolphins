require 'rails_helper'

describe AStream::BaseAction do
  before do
    module Actions
      module Users
        class Show < AStream::BaseAction
        end

        class Approve < AStream::BaseAction
          def query_attributes
            [:number]
          end
        end
      end
    end
  end

  after do
    %w(Show Approve).each { |a| Actions::Users.send(:remove_const, a.to_sym) }
  end

  let(:show_action) { Actions::Users::Show }
  let(:approve_action) { Actions::Users::Approve }

  context 'connector block is specified' do
    before do
      Actions::Users::Approve.class_eval do
        query_by('users#show') { |r| {number: r * 2} }
      end
    end

    specify { expect(approve_action.can_accept_action?(Actions::Users::Show)).to eq(true) }
    specify { expect(approve_action.able_accept_action?(Actions::Users::Show)).to eq(true) }
  end

  context 'connector block is not specified' do
    specify { expect(approve_action.can_accept_action?(Actions::Users::Show)).to eq(false) }
    specify { expect(approve_action.able_accept_action?(Actions::Users::Show)).to eq(false) }
  end

  describe '.action_name' do
    specify { expect(Actions::Users::Show.action_name).to eq('users#show') }
    specify { expect(Actions::Users::Approve.action_name).to eq('users#approve') }
  end

  describe '.pipe_data_from' do
    context 'connector block is specified' do
      before do
        Actions::Users::Approve.class_eval do
          query_by('users#show') { |r| r * 2 }
        end

        Actions::Users::Show.class_eval do
          query_by('users#approve') { |r| r / 2 }
        end
      end

      specify { expect(approve_action.pipe_data_from(show_action, 2)).to eq(4) }
      specify { expect(show_action.pipe_data_from(approve_action, 2)).to eq(1) }
    end

    context 'connector block is not specified' do
      specify { expect(approve_action.pipe_data_from(show_action, 2)).to eq(nil) }
    end
  end
end
