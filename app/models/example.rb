class Example < ActiveRecord::Base
  belongs_to :resource
  has_many :example_fields, dependent: :destroy

  validates :e_id, presence: true

  accepts_nested_attributes_for :example_fields
  default_scope { order(id: :desc) }
end
