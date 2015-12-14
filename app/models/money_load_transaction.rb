class MoneyLoadTransaction < ActiveRecord::Base
  belongs_to :bookmaker
  validates :ammount_rub, :currency, :bookmaker_id, presence: true
  before_validation :check_ammount, on: :create

  default_scope { order(performed_at: :asc) }

  def check_ammount
    if self.currency != 0 && self.ammount.blank?
      self.errors.add :ammount, :blank
    end
  end
end
