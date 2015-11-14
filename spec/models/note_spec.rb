require 'rails_helper'

describe Note do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:comment) }
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:notable_id) }
  it { is_expected.to validate_presence_of(:notable_type) }
  it { is_expected.to validate_length_of(:title).is_at_most(255) }

  it { is_expected.to belong_to(:notable) }
  it { is_expected.to belong_to(:user) }
end
