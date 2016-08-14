class ApiGroup < ActiveRecord::Base
  has_many :endpoints, dependent: :destroy
  validates :title, :description, presence: true

  default_scope { order(:title) }
end
