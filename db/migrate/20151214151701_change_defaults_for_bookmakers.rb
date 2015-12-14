class ChangeDefaultsForBookmakers < ActiveRecord::Migration
  def up
    change_column :bookmakers, :currency, :integer, default: 0
  end
end
