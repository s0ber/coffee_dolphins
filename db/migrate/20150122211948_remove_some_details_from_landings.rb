class RemoveSomeDetailsFromLandings < ActiveRecord::Migration
  def change
    remove_column :landings, :max_click_cost, :decimal
    remove_column :landings, :old_price, :decimal
  end
end
