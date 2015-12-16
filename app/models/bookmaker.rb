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

  def loaded_ammount_rub
    transactions.to_a.select { |t| t.kind_human == :load }.map(&:ammount_rub).sum
  end

  def loaded_ammount
    transactions.to_a.select { |t| t.kind_human == :load }.map(&:ammount).sum
  end

  def ammount_rub
    transactions.map(&:ammount_rub).sum
  end

  def ammount
    transactions.map(&:ammount).sum
  end

  def exchange_rate
    if loaded_ammount == 0
      0
    else
      loaded_ammount_rub / loaded_ammount
    end
  end
end
