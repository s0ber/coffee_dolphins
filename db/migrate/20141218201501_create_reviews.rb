class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :author
      t.boolean :author_gender, default: true
      t.text :text
      t.belongs_to :landing, index: true

      t.timestamps
    end
  end
end
