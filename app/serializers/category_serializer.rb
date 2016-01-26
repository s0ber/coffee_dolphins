class CategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :slug, :html_title, :meta_description
end
