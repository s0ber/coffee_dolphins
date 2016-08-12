class Type < ActiveRecord::Base
  validates :name, :description, presence: true
  validates :name, uniqueness: true

  default_scope { order(:name) }
end
