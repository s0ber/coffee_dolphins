class SearchKeyword < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true
  belongs_to :position
end
