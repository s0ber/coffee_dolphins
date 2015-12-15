class Bet < ActiveRecord::Base
  belongs_to :fork
  belongs_to :bookmaker
  before_validation :check_bookmaker_has_enough_money

  validates :ammount_rub, :prize, :bookmaker_id, :fork_id, :outcome, presence: true
  default_scope { order(:id) }

  def check_bookmaker_has_enough_money
    if self.ammount_rub && self.bookmaker.ammount_rub < self.ammount_rub
      self.errors.add :ammount_rub, :not_enough_bookmaker_money
    end
  end

  def result
    if self.fork.winning_bet_id
      self.fork.winning_bet_id == self.id ? :bet_plus : :bet_minus
    else
      :pending
    end
  end
end
