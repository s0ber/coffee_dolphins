require 'rails_helper'

describe Fork do
  it { is_expected.to have_many(:bets).dependent(:destroy) }
end
