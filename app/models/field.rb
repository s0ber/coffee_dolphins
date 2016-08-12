class Field < ActiveRecord::Base
  belongs_to :type
  belongs_to :resource
  acts_as_list scope: :resource, top_of_list: 0

  validates :name, :type_id, presence: true
  validates :name, uniqueness: true
end
