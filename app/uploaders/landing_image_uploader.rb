# encoding: utf-8

class LandingImageUploader < BaseImageUploader
  version :gallery do
    process resize_to_fit: [620, 620]
    process quality: 100
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}"
  end
end
