class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.string :slug
      t.text :description
      t.string :html_title
      t.string :meta_keywords
      t.string :meta_description

      t.timestamps
    end
  end
end
