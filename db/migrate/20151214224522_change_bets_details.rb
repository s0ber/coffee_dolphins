class ChangeBetsDetails < ActiveRecord::Migration
  def change
    rename_column :bets, :ammount, :ammount_rub
  end
end
