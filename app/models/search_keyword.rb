class SearchKeyword < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :position

  default_scope { order(:created_at) }
end
