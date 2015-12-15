class Fork < ActiveRecord::Base
  belongs_to :bet_line
  validates :title, presence: true
  has_many :bets, dependent: :destroy
  accepts_nested_attributes_for :bets, allow_destroy: true

  def status
    self.winning_bet_id ? :played_out : :pending
  end
end
