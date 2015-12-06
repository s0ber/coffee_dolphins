require 'rails_helper'

describe AStream::BaseAction do
  before do
    module Users
      class Show < AStream::CollectionAction
      end
    end
  end

  after do
    %w(Show).each { |a| Users.send(:remove_const, a.to_sym) }
  end

  let(:show_action) { Users::Show }

  describe '.collection_action?' do
    specify { expect(show_action.collection_action?).to eq(true) }
  end
end
