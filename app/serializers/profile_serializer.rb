class ProfileSerializer < ActiveModel::Serializer
	include NullAttributeReplacer
  attributes :id, :name, :gender, :date_of_birth, :username, :email, :phone, :dummy

  has_one :profile_picture, class_name: "Image::ProfilePicture", serializer: ProfilePictureSerializer
end