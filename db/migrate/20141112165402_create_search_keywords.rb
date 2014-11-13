class CreateSearchKeywords < ActiveRecord::Migration
  def change
    create_table :search_keywords do |t|
      t.string :title
      t.integer :search_count
      t.belongs_to :position, index: true

      t.timestamps
    end
  end
end
