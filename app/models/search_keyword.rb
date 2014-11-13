class SearchKeyword < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :position
end
