class AddDetailsToBets < ActiveRecord::Migration
  def change
    add_column :bets, :outcome, :string
  end
end
