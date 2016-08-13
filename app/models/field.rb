class Field < ActiveRecord::Base
  belongs_to :type
  belongs_to :resource
  acts_as_list scope: :resource, top_of_list: 0

  validates :name, :type_id, :resource_id, presence: true
end
