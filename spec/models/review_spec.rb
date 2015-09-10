require 'rails_helper'

describe Review do
  it { is_expected.to validate_presence_of(:author) }
  it { is_expected.to validate_presence_of(:landing_id) }
  it { is_expected.to belong_to(:landing) }

  describe '#by_male?' do
    context 'review created by male' do
      subject { create(:review, author_gender: true) }
      specify { expect(subject).to be_by_male }
    end

    context 'review created by female' do
      subject { create(:review, author_gender: false) }
      specify { expect(subject).not_to be_by_male }
    end
  end
end
