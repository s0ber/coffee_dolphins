class Fork < ActiveRecord::Base
  belongs_to :bet_line
  validates :title, presence: true
  has_many :bets, dependent: :destroy
  accepts_nested_attributes_for :bets, allow_destroy: true

  def status
    self.winning_bet_id ? :played_out : :pending
  end

  def ammount_rub
    self.bets.map(&:ammount_rub).sum
  end

  def min_profit
    self.bets.map(&:prize).min - self.ammount_rub
  end

  def max_profit
    self.bets.map(&:prize).max - self.ammount_rub
  end

  def min_profit_percent
    (self.min_profit / self.ammount_rub) * 100
  end

  def max_profit_percent
    (self.max_profit / self.ammount_rub) * 100
  end
end
