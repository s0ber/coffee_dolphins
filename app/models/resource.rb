class Resource < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true

  default_scope { order(:name) }
end
