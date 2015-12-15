class Transaction < ActiveRecord::Base
  KINDS = {
    0 => :load,
    1 => :bet,
    2 => :result_plus,
    3 => :result_minus
  }

  belongs_to :bookmaker
  validates :ammount_rub, :currency, :bookmaker_id, presence: true
  before_validation :check_ammount

  default_scope { order(performed_at: :asc) }

  def check_ammount
    if self.currency == 0
      self.ammount = self.ammount_rub
    else
      if self.ammount.blank?
        self.errors.add :ammount, :blank
      end
    end
  end
end