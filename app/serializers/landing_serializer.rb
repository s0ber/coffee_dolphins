class LandingSerializer < ActiveModel::Serializer
  attributes :id, :title, :slug, :_status
  has_one :position
  has_one :category
end
