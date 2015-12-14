class Fork < ActiveRecord::Base
  belongs_to :bet_line
  has_many :bets, dependent: :destroy
end
