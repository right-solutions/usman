class Image::FeatureImage < Image::Base
	mount_uploader :image, FeatureImageUploader
end
