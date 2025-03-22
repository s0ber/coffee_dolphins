class AddPositionToRelations < ActiveRecord::Migration
  def change
    add_column :relations, :position, :integer
  end
end
