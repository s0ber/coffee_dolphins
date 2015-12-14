require 'rails_helper'

describe MoneyLoadTransaction do
  it { is_expected.to validate_presence_of(:ammount) }
  it { is_expected.to validate_presence_of(:exchange_rate) }
  it { is_expected.to validate_presence_of(:currency) }
  it { is_expected.to validate_presence_of(:bookmaker_id) }
  it { is_expected.to belong_to(:bookmaker) }
end
