class PositionSerializer < ActiveModel::Serializer
  attributes :id, :title, :image_url, :apishops_position_id, :category, :price, :profit, :availability_level
  has_many :search_keywords
end
