class LandingImage < ActiveRecord::Base
  validates :image, :landing_id, presence: true
  validates :alt_text, presence: true, on: :update, if: :landing_published?

  belongs_to :landing
  acts_as_list scope: :landing

  mount_uploader :image, ImageUploader

  def landing_published?
    self.landing.published?
  end
end
