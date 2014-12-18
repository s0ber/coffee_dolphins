class AddDetailsToLandings < ActiveRecord::Migration
  def change
    add_column :landings, :short_description, :text
    add_column :landings, :description_title, :string
    add_column :landings, :description_text, :text
    add_column :landings, :advantages_title, :string
    add_column :landings, :advantages_text, :text
  end
end
