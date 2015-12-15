require 'rails_helper'

describe Bet do
  it { is_expected.to validate_presence_of(:ammount_rub) }
  it { is_expected.to validate_presence_of(:prize) }
  it { is_expected.to validate_presence_of(:bookmaker_id) }
  it { is_expected.to validate_presence_of(:outcome) }
  it { is_expected.to validate_presence_of(:fork_id) }

  it { is_expected.to have_many(:transactions).dependent(:destroy) }
  it { is_expected.to belong_to(:fork) }
  it { is_expected.to belong_to(:bookmaker) }
end
