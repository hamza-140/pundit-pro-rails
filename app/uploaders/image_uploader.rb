# app/uploaders/image_uploader.rb
class ImageUploader < CarrierWave::Uploader::Base
  # Include CarrierWave::MiniMagick for image processing
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_allowlist
    %w(gif png)
  end

  # Process files as they are uploaded:
  process resize_to_fit: [200, 200]

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fill: [200, 200]
  end
end
