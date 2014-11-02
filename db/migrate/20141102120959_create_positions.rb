class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :title
      t.string :category
      t.decimal :price
      t.decimal :profit
      t.integer :availability_level
      t.string :image_url

      t.timestamps
    end
  end
end
