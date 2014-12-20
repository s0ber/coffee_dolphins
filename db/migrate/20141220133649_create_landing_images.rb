class CreateLandingImages < ActiveRecord::Migration
  def change
    create_table :landing_images do |t|
      t.string :image
      t.string :alt_text
      t.string :key
      t.integer :position
      t.boolean :for_gallery, default: false
      t.belongs_to :landing, index: true

      t.timestamps
    end
  end
end
