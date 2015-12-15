class BetLine < ActiveRecord::Base
  has_many :forks, dependent: :destroy
  validates :performed_at, presence: true
  default_scope { order(performed_at: :desc) }
end
