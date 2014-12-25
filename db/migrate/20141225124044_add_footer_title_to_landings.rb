class AddFooterTitleToLandings < ActiveRecord::Migration
  def change
    add_column :landings, :footer_title, :string
  end
end
