class Position < ActiveRecord::Base
  scope :by_creation, -> { order(:created_at) }

  validates :title, :price, :profit, :apishops_position_id, presence: true
  validates :availability_level, inclusion: 0..5
end
