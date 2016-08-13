class AddRelatedResourceToRelations < ActiveRecord::Migration
  def change
    add_reference :relations, :related_resource, index: true
  end
end
