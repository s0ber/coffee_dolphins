class ApiResource < ActiveRecord::Base
  KINDS = {0: :One, 1: :Many}
  KINDS_INVERTED = KINDS.invert

  belongs_to :resource
  belongs_to :endpoint

  validates :kind, :resource_id, :endpoint_id, :guid
end
