class Resource < ActiveRecord::Base
  has_many :fields, -> { order(position: :asc) }, dependent: :destroy

  accepts_nested_attributes_for :fields, allow_destroy: true

  validates :name, presence: true
  validates :name, uniqueness: true

  default_scope { order(:name) }
end
