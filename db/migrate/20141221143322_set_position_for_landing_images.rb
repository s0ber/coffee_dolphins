class SetPositionForLandingImages < ActiveRecord::Migration
  def up
    Landing.all.each do |landing|
      landing.landing_images.each_with_index do |landing_image, index|
        landing_image.update_attribute(:position, index)
      end
    end
  end

  def down
  end
end
