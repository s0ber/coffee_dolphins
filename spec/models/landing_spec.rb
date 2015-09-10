require 'rails_helper'

describe Landing do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_presence_of(:category_id) }
    it { is_expected.to validate_presence_of(:position_id) }
    it { is_expected.to validate_presence_of(:template) }
    it { is_expected.to validate_uniqueness_of(:slug) }

    it { is_expected.to validate_presence_of(:price).on(:update) }
    it { is_expected.to validate_presence_of(:discount).on(:update) }

    context 'landing is published' do
      before(:each) { subject.set_as_published }

      it { is_expected.to validate_presence_of(:_status).on(:update) }
      it { is_expected.to validate_presence_of(:short_description).on(:update) }
      it { is_expected.to validate_presence_of(:subheader_title).on(:update) }
      it { is_expected.to validate_presence_of(:description_title).on(:update) }
      it { is_expected.to validate_presence_of(:description_text).on(:update) }
      it { is_expected.to validate_presence_of(:advantages_title).on(:update) }
      it { is_expected.to validate_presence_of(:advantages_text).on(:update) }
      it { is_expected.to validate_presence_of(:why_question).on(:update) }
      it { is_expected.to validate_presence_of(:reviews_title).on(:update) }
      it { is_expected.to validate_presence_of(:reviews_footer).on(:update) }
      it { is_expected.to validate_presence_of(:video_id).on(:update) }
      it { is_expected.to validate_presence_of(:color).on(:update) }
      it { is_expected.to validate_presence_of(:apishops_article_id).on(:update) }
      it { is_expected.to validate_presence_of(:apishops_site_id).on(:update) }
      it { is_expected.to validate_presence_of(:html_title).on(:update) }
      it { is_expected.to validate_presence_of(:meta_description).on(:update) }
      it { is_expected.to validate_presence_of(:footer_title).on(:update) }
    end

    context 'landing is not published' do
      it { is_expected.not_to validate_presence_of(:short_description).on(:update) }
      it { is_expected.not_to validate_presence_of(:subheader_title).on(:update) }
      it { is_expected.not_to validate_presence_of(:description_title).on(:update) }
      it { is_expected.not_to validate_presence_of(:description_text).on(:update) }
      it { is_expected.not_to validate_presence_of(:advantages_title).on(:update) }
      it { is_expected.not_to validate_presence_of(:advantages_text).on(:update) }
      it { is_expected.not_to validate_presence_of(:why_question).on(:update) }
      it { is_expected.not_to validate_presence_of(:reviews_title).on(:update) }
      it { is_expected.not_to validate_presence_of(:reviews_footer).on(:update) }
      it { is_expected.not_to validate_presence_of(:video_id).on(:update) }
      it { is_expected.not_to validate_presence_of(:color).on(:update) }
      it { is_expected.not_to validate_presence_of(:apishops_article_id).on(:update) }
      it { is_expected.not_to validate_presence_of(:apishops_site_id).on(:update) }
      it { is_expected.not_to validate_presence_of(:html_title).on(:update) }
      it { is_expected.not_to validate_presence_of(:meta_description).on(:update) }
      it { is_expected.not_to validate_presence_of(:footer_title).on(:update) }
    end
  end

  describe 'relations' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to belong_to(:position).touch(true) }
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
    it { is_expected.to have_many(:landing_images).dependent(:destroy) }
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:reviews).allow_destroy(true) }
    it { is_expected.to accept_nested_attributes_for(:landing_images).allow_destroy(true) }
    it { is_expected.to accept_nested_attributes_for(:position).allow_destroy(false) }
  end

  describe 'scopes' do
    describe '.published' do
      subject { described_class }
      let!(:landings) { create_list(:landing, 4) }
      let!(:published_landings) { create_list(:landing, 2) }

      before(:each) do
        published_landings.each do |landing|
          landing.update_attributes!(attributes_for(:landing, :published))
        end
      end

      specify { expect(subject.all).to eq(landings + published_landings) }
      specify { expect(subject.published).to eq(published_landings) }
    end
  end

  describe '#mark_empty_reviews_for_destruction' do
    let(:reviews) { create_list(:review, 5) }
    subject { create(:landing, reviews: reviews) }

    it 'destroys reviews without author when landing is updated' do
      subject.reviews.last(2).each { |review| review.author = '' }
      subject.save!

      expect(subject.reviews).to eq(reviews.first(3))
    end
  end

  describe '#set_as_draft' do
    context 'when landing is created' do
      subject { create(:landing, _status: nil) }
      specify { expect(subject._status).to eql(:draft) }
    end

    context 'when landing is there' do
      subject { create(:landing) }
      before(:each) { subject._status = :published }

      specify do
        expect { subject.set_as_draft }.to change(subject, :status).from(:published).to(:draft)
      end
    end
  end

  describe '#set_as_published' do
    subject { create(:landing) }

    specify do
      expect { subject.set_as_published }.to change(subject, :status).from(:draft).to(:published)
    end
  end
end
