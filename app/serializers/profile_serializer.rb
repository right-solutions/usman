class ProfileSerializer < ActiveModel::Serializer
	include NullAttributeReplacer
  attributes :id, :name, :gender, :date_of_birth, :username, :email, :phone, :dummy, :country_id, :city_id

  has_one :profile_picture, class_name: "Image::ProfilePicture", serializer: ProfilePictureSerializer do
    if object.profile_picture
      object.profile_picture
    else
      object.build_profile_picture
    end
  end
end