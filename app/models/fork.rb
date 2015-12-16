class Fork < ActiveRecord::Base
  belongs_to :bet_line
  has_many :bets, dependent: :destroy

  validates :title, :event_scheduled_at, presence: true

  accepts_nested_attributes_for :bets, allow_destroy: true

  scope :pending, -> { where(winning_bet_id: nil) }
  scope :order_by_event_scheduled_at_asc, -> { order(event_scheduled_at: :asc) }
  scope :order_by_event_scheduled_at_desc, -> { order(event_scheduled_at: :desc) }

  after_save :update_bet_transactions

  def status
    if self.event_scheduled_at
      if self.winning_bet_id
        :played_out
      elsif (self.event_scheduled_at + (1.5).hours) <= Time.zone.now
        :pending_check
      else
        :pending
      end
    else
      :pending_event_time
    end
  end

  def ammount_rub
    self.bets.map(&:ammount_rub).sum
  end

  def min_profit
    (self.bets.map(&:prize).min || 0)
  end

  def max_profit
    (self.bets.map(&:prize).max || 0)
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
      self.prize
    else
      -self.ammount_rub
    end
  end

  def update_bet_transactions
    self.bets.each(&:update_bet_transactions)
  end
end
