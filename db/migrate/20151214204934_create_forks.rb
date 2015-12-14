class CreateForks < ActiveRecord::Migration
  def change
    create_table :forks do |t|
      t.belongs_to :bet_line, index: true

      t.timestamps
    end
  end
end
