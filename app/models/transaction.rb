class Transaction < ActiveRecord::Base
  KINDS = {
    :load => 0,
    :bet => 1,
    :result_plus => 2,
    :result_minus => 3
  }

  belongs_to :bookmaker
  belongs_to :bet
  validates :ammount_rub, :currency, :bookmaker_id, presence: true
  before_validation :check_ammount

  default_scope { order(performed_at: :desc) }

  def check_ammount
    if self.currency == 0
      self.ammount = self.ammount_rub
    else
      if self.ammount.blank?
        self.errors.add :ammount, :blank
      end
    end
  end

  def kind_human
    KINDS.invert[self.kind]
  end
end
