require 'rails_helper'

describe Fork do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to have_many(:bets).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for(:bets).allow_destroy(true) }
end
