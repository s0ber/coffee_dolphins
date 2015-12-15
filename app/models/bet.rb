class Bet < ActiveRecord::Base
  belongs_to :fork
  belongs_to :bookmaker

  validates :ammount_rub, :prize, :bookmaker_id, :fork_id, presence: true
  default_scope { order(:id) }
end
