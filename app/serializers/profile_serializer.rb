class ProfileSerializer < ActiveModel::Serializer
	include NullAttributeReplacer
  attributes :id, :name, :gender, :date_of_birth, :username, :email, :phone
end