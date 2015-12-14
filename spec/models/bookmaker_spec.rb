require 'rails_helper'

describe Bookmaker do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:image) }
  it { is_expected.to validate_presence_of(:currency) }

  describe '#ammount' do
  end
end
