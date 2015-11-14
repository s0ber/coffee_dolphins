require 'rails_helper'

describe SearchKeyword do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to belong_to(:position) }

  describe 'default scope' do
    let!(:keyword_1) { SearchKeyword.create!(name: 'A Keyword', search_count: 10) }
    let!(:keyword_2) { SearchKeyword.create!(name: 'B Keyword', search_count: 100) }

    it 'orders by search count DESC' do
      expect(SearchKeyword.all).to eq([keyword_2, keyword_1])
    end
  end
end
