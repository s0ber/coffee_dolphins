class AddPositionToApiResources < ActiveRecord::Migration
  def change
    add_column :api_resources, :position, :integer
  end
end
