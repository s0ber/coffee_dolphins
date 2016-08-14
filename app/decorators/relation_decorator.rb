class RelationDecorator < ApplicationDecorator
  def related_resource_name
    object.kind_readable == :one ?
      object.related_resource.name :
      object.related_resource.name.pluralize
  end
end
