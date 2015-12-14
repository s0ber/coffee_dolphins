class CreateBetLines < ActiveRecord::Migration
  def change
    create_table :bet_lines do |t|
      t.datetime :performed_at

      t.timestamps
    end
  end
end
