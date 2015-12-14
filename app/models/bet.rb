class Bet < ActiveRecord::Base
  belongs_to :fork
  belongs_to :bookmaker
end
