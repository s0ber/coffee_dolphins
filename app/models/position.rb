class Position < ActiveRecord::Base
  validates :title, :price, :profit, :apishops_position_id, presence: true
  validates :availability_level, inclusion: 0..5

  has_many :search_keywords, dependent: :destroy

  accepts_nested_attributes_for :search_keywords, allow_destroy: true

  scope :order_by_search_count, -> { select('positions.*, avg(search_keywords.search_count) AS sc').joins(:search_keywords).group('positions.id').order('sc DESC') }

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      position = find_by_apishops_position_id(row['apishops_position_id']) || new
      position.attributes = row.to_hash
      position.save!
    end
  end
end
