class CreateBookmakers < ActiveRecord::Migration
  def change
    create_table :bookmakers do |t|
      t.string :title
      t.text :description
      t.string :image
      t.integer :currency

      t.timestamps
    end
  end
end
