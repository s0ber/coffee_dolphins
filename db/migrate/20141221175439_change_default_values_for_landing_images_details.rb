class ChangeDefaultValuesForLandingImagesDetails < ActiveRecord::Migration
  def change
    change_column :landing_images, :alt_text, :string, default: ''
    change_column :landing_images, :key, :string, default: ''

    LandingImage.all.each do |landing_image|
      landing_image.alt_text = '' if landing_image.alt_text.nil?
      landing_image.key = '' if landing_image.key.nil?
      landing_image.save
    end
  end
end
