class ResourceDecorator < ApplicationDecorator
  decorates_association :relations

protected

  def can_remove_object
    Relation.where(related_resource_id: object.id).size == 0
  end

  def confirm_remove_message
    "Remove resource #{object.name}?"
  end
end
