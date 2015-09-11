require 'rails_helper'

describe LandingImage do
  it { is_expected.to validate_presence_of(:image) }
  it { is_expected.to validate_presence_of(:landing_id) }

  it { is_expected.to belong_to(:landing).touch(true) }
end
