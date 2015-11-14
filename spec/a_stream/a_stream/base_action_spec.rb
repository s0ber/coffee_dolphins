require 'rails_helper'

describe AStream::BaseAction do
  before do
    module Actions
      module Users
        class Show < AStream::BaseAction
        end

        class Approve < AStream::BaseAction
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

  describe '.permitted_query_params' do
    let(:admin) { create(:user, :admin) }
    let(:moder) { create(:user, :moder) }

    context 'params specified as a list of symbols' do
      before do
        Actions::Users::Show.class_eval do
          query_params :full_name, :gender
        end
      end
      specify { expect(show_action.permitted_query_params(admin)).to eq [:full_name, :gender] }
    end

    context 'query params is a block' do
      before do
        Actions::Users::Show.class_eval do
          query_params do |performer|
            if performer.admin?
              [:full_name, :gender]
            else
              [:full_name]
            end
          end
        end
      end
      specify { expect(show_action.permitted_query_params(admin)).to eq [:full_name, :gender] }
      specify { expect(show_action.permitted_query_params(moder)).to eq [:full_name] }
    end
  end

  describe '.permitted_safe_attributes' do
    let(:admin) { create(:user, :admin) }
    let(:moder) { create(:user, :moder) }

    context 'safe attributes specified as a list of symbols' do
      before do
        Actions::Users::Show.class_eval do
          safe_attributes :full_name, :gender
        end
      end
      specify { expect(show_action.permitted_safe_attributes(admin)).to eq [:full_name, :gender] }
    end

    context 'safe attributes specified as a block' do
      before do
        Actions::Users::Show.class_eval do
          safe_attributes do |performer|
            if performer.admin?
              [:full_name, :gender]
            else
              [:full_name]
            end
          end
        end
      end
      specify { expect(show_action.permitted_safe_attributes(admin)).to eq [:full_name, :gender] }
      specify { expect(show_action.permitted_safe_attributes(moder)).to eq [:full_name] }
    end
  end

  describe '.permit_resource?' do
    let(:admin) { create(:user, :admin) }
    let(:moder) { create(:user, :moder) }

    context 'permission check specified as a scalar value' do
      context 'it is truthy' do
        before do
          Actions::Users::Show.class_eval do
            permit_resource true
          end
        end

        specify { expect(show_action.permit_resource?(admin, nil)).to eq true }
      end

      context 'it is falsey' do
        before do
          Actions::Users::Show.class_eval do
            permit_resource false
          end
        end

        specify { expect(show_action.permit_resource?(admin, nil)).to eq false }
      end
    end

    context 'permission check specified as a block' do
      before do
        Actions::Users::Show.class_eval do
          permit_resource do |performer, resource|
            if performer.admin?
              true
            else
              false
            end
          end
        end
      end

      specify { expect(show_action.permit_resource?(admin, nil)).to eq true }
      specify { expect(show_action.permit_resource?(moder, nil)).to eq false }
    end
  end

  describe '.allows_to_include_resource?' do
    context 'included resources are not specified' do
      specify { expect(show_action.allows_to_include_resource?(:notes)).to eq false }
    end

    context 'included resources are specified' do
      before do
        Actions::Users::Show.class_eval do
          included_resources :notes, :secrets
        end
      end

      specify { expect(show_action.allows_to_include_resource?(:notes)).to eq true }
    end
  end

  describe '.perform_read' do
    let(:admin) { create(:user, :admin) }
    let(:moder) { create(:user, :moder) }

    context 'perform_read instance method is specified' do
      before do
        Actions::Users::Show.class_eval do
          def perform_read(performer, query)
            performer.admin? ? query[:number] * 2 : query[:number] / 2
          end
        end
      end

      specify { expect(show_action.perform_read(admin, number: 2)).to eq 4 }
      specify { expect(show_action.perform_read(moder, number: 2)).to eq 1 }
    end

    context 'perform_read instance method is not specified' do
      specify { expect{ show_action.perform_read(admin, number: 2) }.to raise_error NoMethodError }
      specify { expect{ show_action.perform_read(moder, number: 2) }.to raise_error NoMethodError }
    end
  end

  describe '.pipe_data_from' do
    context 'connector block is specified' do
      before do
        Actions::Users::Show.class_eval do
          query_by('users#approve') { |r| r / 2 }
        end

        Actions::Users::Approve.class_eval do
          query_by('users#show') { |r| r * 2 }
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
