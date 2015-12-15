class Bookmaker < ActiveRecord::Base
  validates :title, :description, :currency, :image, presence: true
  has_many :transactions, dependent: :destroy
  mount_uploader :image, ImageUploader

  def self.by_ammount_rub
    Bookmaker.all.sort_by(&:ammount_rub).reverse
  end

  def self.ammount(bookmakers)
    bookmakers.map { |b| b.model.ammount_rub }.sum.to_s + ' RUB'
  end

  def ammount_rub
    transactions.map(&:ammount_rub).sum
  end

  def ammount
    transactions.map(&:ammount).sum
  end

  def exchange_rate
    if ammount == 0
      0
    else
      (ammount_rub / ammount).ceil(2)
    end
  end
end
