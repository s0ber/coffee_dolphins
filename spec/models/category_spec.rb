require 'rails_helper'

describe Category do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:slug) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:html_title) }
  it { is_expected.to validate_presence_of(:meta_description) }

  it { is_expected.to have_many(:landings).dependent(:delete_all) }

  describe 'default scope' do
    let!(:category_1) { create(:category, title: 'B category') }
    let!(:category_2) { create(:category, title: 'A category') }

    it 'orders by ascending title' do
      expect(Category.all).to eq([category_2, category_1])
    end
  end
end
