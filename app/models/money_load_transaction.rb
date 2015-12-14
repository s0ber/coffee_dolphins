class MoneyLoadTransaction < ActiveRecord::Base
  belongs_to :bookmaker
  validates :ammount, :exchange_rate, :currency, :bookmaker_id, :performed_at, presence: true
end
