class LandingImage < ActiveRecord::Base
  validates :image, :landing_id, presence: true
  validates :key, presence: true, on: :update
  validates :key, uniqueness: true
  validates :alt_text, presence: true, on: :update, if: :landing_published?

  belongs_to :landing

  default_scope { order(:created_at) }

  mount_uploader :image, LandingImageUploader

  def landing_published?
    self.landing.published?
  end
end
