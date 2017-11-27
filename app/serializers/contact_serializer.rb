class ContactSerializer < ActiveModel::Serializer
	include NullAttributeReplacer
  attributes :id, :name, :account_type, :email, :address, :contact_number_1, :contact_number_2, :contact_number_3, :contact_number_4

  has_one :profile_picture, class_name: "Image::ProfilePicture", serializer: ProfilePictureSerializer do
    if object.done_deal_user && object.done_deal_user.profile_picture
      object.done_deal_user.profile_picture
    else
      Image::ProfilePicture.new
    end
  end
end