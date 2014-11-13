class SearchKeyword < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  belongs_to :position
end
