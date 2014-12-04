class AddLikedToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :liked, :boolean, default: false
  end
end
