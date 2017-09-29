class OwnerSerializer < ActiveModel::Serializer
  include NullAttributeReplacer
  attributes :id, :name, :email

 	has_one :registration, class_name: "Registration", serializer: RegistrationSerializer do
 		if object.registration
      object.registration
    else
      object.build_registration
    end
 	end

  has_one :profile_picture, class_name: "Image::ProfilePicture", serializer: ProfilePictureSerializer do
    if object.profile_picture
      object.profile_picture
    else
      object.build_profile_picture
    end
  end
end