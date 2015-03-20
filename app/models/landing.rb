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
    aquamarine: 9,
    purple_light: 10
  }

  COLORS = {
    blue: '#54709b',
    green: '#50914f',
    red: '#bf363d',
    pink: '#B64361',
    blue_light: '#54799e',
    purple: '#83628e',
    olive: '#6d8769',
    bronze: '#887f67',
    cocoa: '#9c755c',
    aquamarine: '#618d8d',
    purple_light: '#63708e'
  }

  DISCOUNTS = {
    30 => '30%',
    40 => '40%',
    50 => '50%',
    70 => '70%'
  }.invert

  include StatusHolder

  before_validation :set_as_draft, on: :create
  before_validation :mark_empty_reviews_for_destruction, on: :update

  validates :title, :slug, :category_id, :position_id, :_status, presence: true
  validates :slug, uniqueness: true
  validates :short_description,
            :subheader_title,
            :description_title,
            :description_text,
            :advantages_title,
            :advantages_text,
            :why_question,
            :reviews_title,
            :reviews_footer,
            :video_id,
            :color,
            :apishops_article_id,
            :apishops_site_id,
            :html_title,
            :meta_description,
            :footer_title,
              presence: true, on: :update, if: :published?

  validates :price, :discount, presence: true, on: :update

  belongs_to :category
  belongs_to :position, touch: true
  has_many :reviews, dependent: :destroy
  has_many :landing_images, -> { order(position: :asc) }, dependent: :destroy

  accepts_nested_attributes_for :reviews, allow_destroy: true
  accepts_nested_attributes_for :landing_images, allow_destroy: true
  accepts_nested_attributes_for :position

  scope :published, -> { where(_status: :published) }

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
