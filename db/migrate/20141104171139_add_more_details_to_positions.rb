class AddMoreDetailsToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :apishops_position_id, :integer
    add_column :positions, :apishops_category_id, :integer
  end
end
