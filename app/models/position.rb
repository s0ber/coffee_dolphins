class Position < ActiveRecord::Base
  scope :by_creation, -> { order(:created_at) }

  validates :title, :price, :profit, presence: true
end
