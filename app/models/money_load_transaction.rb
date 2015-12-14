class MoneyLoadTransaction < ActiveRecord::Base
  belongs_to :bookmaker
  validates :ammount, :exchange_rate, :currency, :bookmaker_id, presence: true
end
