class Landing < ActiveRecord::Base
  COLOR_SCHEMES = {
    blue: 0,
    green: 1,
    red: 2,
    pink: 3,
    blue_light: 4,
    purple: 5,
    olive: 6,
    bronze: 7,
    cocoa: 8,
    test: 9
  }

  include StatusHolder

  before_validation :set_as_draft, on: :create
  before_validation :mark_empty_reviews_for_destruction, on: :update

  validates :title, :slug, :category_id, :position_id, :_status, presence: true
  validates :slug, uniqueness: true
  validates :short_description,
            :description_title,
            :description_text,
            :advantages_title,
            :advantages_text,
            :why_question,
            :reviews_title,
            :price,
            :old_price,
            :apishops_price,
            :max_click_cost,
            :video_id,
            :color,
            :apishops_article_id,
            :html_title,
            :meta_description,
            :footer_title,
              presence: true, on: :update, if: :published?

  belongs_to :category
  belongs_to :position
  has_many :reviews, dependent: :destroy
  has_many :landing_images, -> { order(position: :asc) }, dependent: :destroy

  accepts_nested_attributes_for :reviews, allow_destroy: true
  accepts_nested_attributes_for :landing_images, allow_destroy: true

  default_scope { order(:created_at) }

  def mark_empty_reviews_for_destruction
    self.reviews.each do |review|
      review.mark_for_destruction if review.author.blank?
    end
  end

  def set_as_draft
    self._status = :draft
  end

  def color_scheme
    COLOR_SCHEMES.invert[self.color]
  end

  def set_as_published
    self._status = :published
  end

  def published?
    self.status == :published
  end

  def draft?
    self.status == :draft
  end
end
