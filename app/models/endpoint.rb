class Endpoint < ActiveRecord::Base
  REQUEST_METHODS = {GET: 0, POST: 1, PATCH: 2, DELETE: 3}
  REQUEST_METHODS_INVERTED = REQUEST_METHODS.invert

  belongs_to :api_group
  has_many :api_resources

  validates :request_method, :path, :api_group_id, presence: true

  accepts_nested_attributes_for :api_resources
end
