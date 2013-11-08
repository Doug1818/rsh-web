# encoding: utf-8
class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  def default_url
    ActionController::Base.helpers.asset_path("default-avatar.png")
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  version :xsmall do
    process resize_to_fill: [30, 30, gravity='NorthWest']
  end

  version :small do
    process resize_to_fill: [60, 60, gravity='NorthWest']
  end

  version :medium do
    process resize_to_fill: [123, 123, gravity='NorthWest']
  end

  version :large do
    process resize_to_fill: [201, 201, gravity='NorthWest']
  end
end
