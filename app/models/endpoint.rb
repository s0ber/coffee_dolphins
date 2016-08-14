class Endpoint < ActiveRecord::Base
  REQUEST_METHODS = {GET: 0, POST: 1, PATCH: 2, DELETE: 3}
  REQUEST_METHODS_INVERTED = REQUEST_METHODS.invert

  belongs_to :api_group

  validates :request_method, :path, presence: true
end
