class RemoveResultFromBets < ActiveRecord::Migration
  def change
    remove_column :bets, :result, :integer
  end
end
