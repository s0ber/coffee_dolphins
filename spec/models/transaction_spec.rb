require 'rails_helper'

describe Transaction do
  it { is_expected.to validate_presence_of(:ammount_rub) }
  it { is_expected.to validate_presence_of(:currency) }
  it { is_expected.to validate_presence_of(:bookmaker_id) }

  it { is_expected.to belong_to(:bookmaker) }
  it { is_expected.to belong_to(:bet) }
end
