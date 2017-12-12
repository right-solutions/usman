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

  has_one :country, class_name: "Country", serializer: CountryPreviewSerializer do
 		if object.country
      object.country
    else
      object.build_country
    end
 	end
 		
 	has_one :city, class_name: "City", serializer: CityPreviewSerializer do
 		if object.city
      object.city
    else
      object.build_city
    end
 	end
end