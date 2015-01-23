class AddMoreDetailsToLandings < ActiveRecord::Migration
  def change
    add_column :landings, :apishops_site_id, :integer
    add_column :landings, :discount, :integer, default: 30
  end
end
