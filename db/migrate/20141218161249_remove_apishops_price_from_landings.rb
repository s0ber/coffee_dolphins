class RemoveApishopsPriceFromLandings < ActiveRecord::Migration
  def change
    remove_column :landings, :apishops_price, :decimal
  end
end
