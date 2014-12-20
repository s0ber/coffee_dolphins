class LandingImage < ActiveRecord::Base
  validates :image, :key, :landing_id, presence: true
  validates :alt_text, presence: true, on: :update, if: :landing_published?
  validates :key, uniqueness: true

  belongs_to :landing

  default_scope { order(:created_at) }

  mount_uploader :image, ImageUploader

  def landing_published?
    self.landing.published?
  end
end
