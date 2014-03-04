require 'carrierwave/processing/mime_types'
# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png pdf doc docx xls xlsx ppt pptx)
  end

  include CarrierWave::MimeTypes
  process :set_content_type
end
