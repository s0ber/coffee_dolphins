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
    self.forks.map { |fork| fork.bets.map(&:ammount_rub).sum }.sum
  end
end
