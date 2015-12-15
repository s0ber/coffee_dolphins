class Fork < ActiveRecord::Base
  belongs_to :bet_line
  validates :title, presence: true
  has_many :bets, dependent: :destroy
  accepts_nested_attributes_for :bets, allow_destroy: true
  default_scope { order(:id) }

  def status
    self.winning_bet_id ? :played_out : :pending
  end

  def ammount_rub
    self.bets.map(&:ammount_rub).sum
  end

  def min_profit
    (self.bets.map(&:prize).min || 0) - self.ammount_rub
  end

  def max_profit
    (self.bets.map(&:prize).max || 0) - self.ammount_rub
  end

  def prize
    if self.status == :played_out
      self.bets.to_a.find { |bet| bet.id == self.winning_bet_id }.prize
    else
      0
    end
  end

  def profit
    if self.status == :played_out
      self.prize - self.ammount_rub
    else
      -self.ammount_rub
    end
  end
end
