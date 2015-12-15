class AddPlayedOutAtToForks < ActiveRecord::Migration
  def change
    add_column :forks, :played_out_at, :datetime
  end
end
