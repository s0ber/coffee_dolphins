class CreateLandings < ActiveRecord::Migration
  def change
    create_table :landings do |t|
      t.string :title
      t.string :slug
      t.decimal :price
      t.decimal :old_price
      t.decimal :apishops_price
      t.decimal :max_click_cost
      t.string :video_url
      t.integer :color, limit: 1
      t.string :apishops_article_id
      t.string :meta_description
      t.string :html_title
      t.belongs_to :category, index: true
      t.string :_status
      t.belongs_to :position, index: true

      t.timestamps
    end
  end
end
