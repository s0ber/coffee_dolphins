class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.integer :kind, limit: 1
      t.belongs_to :resource, index: true
      t.string :name

      t.timestamps
    end
  end
end
