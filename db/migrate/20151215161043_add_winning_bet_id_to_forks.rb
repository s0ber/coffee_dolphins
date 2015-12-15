class AddWinningBetIdToForks < ActiveRecord::Migration
  def change
    add_column :forks, :winning_bet_id, :integer
  end
end
