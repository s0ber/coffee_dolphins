class RemoveKeyFromLandingImages < ActiveRecord::Migration
  def change
    remove_column :landing_images, :key, :string
  end
end
