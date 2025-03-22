class Type < ActiveRecord::Base
  has_many :fields
  validates :name, :description, presence: true
  validates :name, uniqueness: true

  default_scope { order(:name) }
end
