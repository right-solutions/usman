class RegistrationSerializer < ActiveModel::Serializer
	include NullAttributeReplacer

	attributes :id, :dialing_prefix, :mobile_number, :status, :user_id, :country_id, :city_id

 	has_one :user, class_name: "User", serializer: ProfileSerializer do
 		if object.user
      object.user
    else
      object.build_user
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