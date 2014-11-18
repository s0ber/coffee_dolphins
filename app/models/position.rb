class Position < ActiveRecord::Base
  validates :title, :price, :profit, :apishops_position_id, presence: true
  validates :availability_level, inclusion: 0..5

  has_many :search_keywords, dependent: :destroy

  accepts_nested_attributes_for :search_keywords, allow_destroy: true

  default_scope { order(availability_level: :desc, created_at: :asc) }

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      position = find_by_apishops_position_id(row['apishops_position_id']) || new
      position.attributes = row.to_hash
      position.save!
    end
  end
end
