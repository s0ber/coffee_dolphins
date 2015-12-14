require 'rails_helper'

describe BetLine do
  it { is_expected.to have_many(:forks).dependent(:destroy) }
end
