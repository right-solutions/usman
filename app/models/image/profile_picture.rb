class Image::ProfilePicture < Image::Base
  mount_uploader :image, ProfilePictureUploader
end
