class AddTemplateToLandings < ActiveRecord::Migration
  def change
    add_column :landings, :template, :integer, default: 0
  end
end
