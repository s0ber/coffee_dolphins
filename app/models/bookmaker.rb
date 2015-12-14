class Bookmaker < ActiveRecord::Base
  validates :title, :description, :currency, :image, presence: true
  has_many :money_load_transactions, dependent: :destroy
  mount_uploader :image, ImageUploader

  def self.by_ammount_rub
    Bookmaker.all.sort_by(&:ammount_rub).reverse
  end

  def ammount_rub
    money_load_transactions.map(&:ammount_rub).sum
  end

  def ammount
    money_load_transactions.map(&:ammount).sum
  end

  def exchange_rate
    if ammount == 0
      0
    else
      ammount_rub / ammount
    end
  end
end
