class AddEventScheduledAtToForks < ActiveRecord::Migration
  def change
    add_column :forks, :event_scheduled_at, :datetime
  end
end
