class Bookmaker < ActiveRecord::Base
  validates :title, :description, :currency, :image, presence: true
  mount_uploader :image, ImageUploader
end
