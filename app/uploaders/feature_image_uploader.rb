class FeatureImageUploader < ImageUploader
	
	def store_dir
    "uploads/feature_images/#{model.id}"
  end

	version :large do
    process :resize_to_fill => [400, 400]
  end

  version :small do
    process :resize_to_fill => [100, 100]
  end
  
end
