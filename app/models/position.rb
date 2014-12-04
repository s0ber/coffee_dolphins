class Position < ActiveRecord::Base
  validates :title, :price, :profit, :apishops_position_id, presence: true
  validates :availability_level, inclusion: 0..5

  has_many :search_keywords, dependent: :destroy
  has_many :notes, as: :notable, dependent: :destroy

  accepts_nested_attributes_for :search_keywords, allow_destroy: true

  scope :favorite, -> { where(liked: true) }
  scope :order_by_search_count, -> { select('positions.*, coalesce(sum(search_keywords.search_count), 0) AS sk_count')
                                      .joins('LEFT OUTER JOIN search_keywords ON search_keywords.position_id = positions.id')
                                      .group('positions.id').order('sk_count DESC') }

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      position = find_by_apishops_position_id(row['apishops_position_id']) || new
      position.attributes = row.to_hash
      position.save!
    end
  end
end
