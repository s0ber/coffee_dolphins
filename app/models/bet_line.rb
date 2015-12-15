class BetLine < ActiveRecord::Base
  has_many :forks, dependent: :destroy
  validates :performed_at, presence: true
  default_scope { order(performed_at: :desc) }

  def pending_forks
    self.forks.to_a.select { |fork| fork.status == :pending }
  end


  def played_out_forks
    self.forks.to_a.select { |fork| fork.status == :played_out }
  end

  def ammount_rub
    self.forks.map(&:ammount_rub).sum
  end

  def min_profit
    self.forks.map(&:min_profit).sum
  end

  def max_profit
    self.forks.map(&:max_profit).sum
  end

  def min_profit_percent
    ((self.min_profit / self.ammount_rub) * 100).round(1)
  end

  def max_profit_percent
    ((self.max_profit / self.ammount_rub) * 100).round(1)
  end

  def prize
    self.forks.map(&:prize).sum
  end

  def profit
    self.forks.map(&:profit).sum
  end

  def profit_percent
    ((self.profit / self.ammount_rub) * 100).round(1)
  end
end
