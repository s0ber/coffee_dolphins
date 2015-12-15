class Bet < ActiveRecord::Base
  belongs_to :fork
  belongs_to :bookmaker
  has_many :transactions, dependent: :destroy
  before_validation :check_bookmaker_has_enough_money
  after_validation :create_bet_transactions

  validates :ammount_rub, :prize, :bookmaker_id, :fork_id, :outcome, presence: true
  default_scope { order(:outcome) }

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

  def ammount
    if Currency::LIST[bookmaker.currency] != :RUB
      (self.ammount_rub / bookmaker.exchange_rate).round(1)
    end
  end

  private

  def create_bet_transactions
    self.transactions.destroy_all
    self.transactions << Transaction.create!(bookmaker: self.bookmaker,
                                             kind: Transaction::KINDS[:bet],
                                             ammount_rub: self.ammount_rub * -1,
                                             ammount: self.ammount && self.ammount * -1,
                                             currency: self.bookmaker.currency,
                                             performed_at: self.fork.bet_line.performed_at)
  end
end
