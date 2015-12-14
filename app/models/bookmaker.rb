class Bookmaker < ActiveRecord::Base
  validates :title, :description, :currency, :image, presence: true
  has_many :money_load_transactions, dependent: :destroy
  mount_uploader :image, ImageUploader
end
