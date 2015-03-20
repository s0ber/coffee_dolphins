class LandingImage < ActiveRecord::Base
  validates :image, :landing_id, presence: true
  validates :alt_text, presence: true, on: :update, if: :landing_published?

  belongs_to :landing, touch: true
  acts_as_list scope: :landing, top_of_list: 0

  scope :for_gallery, -> { where(for_gallery: true) }

  mount_uploader :image, ImageUploader

  def landing_published?
    self.landing.published?
  end
end
