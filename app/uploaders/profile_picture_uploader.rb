class ProfilePictureUploader < ImageUploader

  def store_dir
    "uploads/profile_pictures/#{model.id}"
  end

	version :large do
    process :resize_to_fill => [800, 800]
  end

  version :small do
    process :resize_to_fill => [200, 200]
  end
  
end
