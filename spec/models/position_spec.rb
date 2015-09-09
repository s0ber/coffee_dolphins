require 'rails_helper'

describe Position do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:profit) }
    it { is_expected.to validate_presence_of(:apishops_position_id) }
    it { is_expected.to validate_inclusion_of(:availability_level).in_range(0..5) }
  end

  describe 'relations' do
    it { is_expected.to have_many(:search_keywords).dependent(:destroy) }
    it { is_expected.to have_many(:notes).dependent(:destroy) }
    it { is_expected.to have_one(:landing) }
  end

  describe 'nested_attributes' do
    it { is_expected.to accept_nested_attributes_for(:search_keywords).allow_destroy(true) }
  end

  describe 'scopes' do
    subject { described_class }
    let!(:positions) { create_list(:position, 4) }
    let!(:favorite_positions) { create_list(:position, 2, :favorite) }

    specify { expect(subject.favorite).to eq(favorite_positions) }
  end

  describe '#has_landing?' do
    context 'has landing' do
      let(:landing) { create(:landing) }
      before(:each) { subject.landing = landing }

      specify { expect(subject.has_landing?).to eq(true) }
    end

    context 'has not landing' do
      specify { expect(subject.has_landing?).to eq(false) }
    end
  end
end
