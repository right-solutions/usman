class ProfilePictureUploader < ImageUploader

  def store_dir
    "uploads/profile_pictures/#{model.id}"
  end

	version :large do
    process :resize_to_fill => [400, 400]
  end

  version :small do
    process :resize_to_fill => [100, 100]
  end

  def default_url
    'default.png'
  end
  
end
