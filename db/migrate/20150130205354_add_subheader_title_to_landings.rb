class AddSubheaderTitleToLandings < ActiveRecord::Migration
  def change
    add_column :landings, :subheader_title, :string
  end
end
