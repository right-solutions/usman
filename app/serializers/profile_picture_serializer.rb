class ProfilePictureSerializer < ActiveModel::Serializer
  include NullAttributeReplacer
  
  attributes :id, :created_at, :profile_id
  attributes :image_large_path, :image_small_path
  	
  def profile_id
  	object.imageable_id
  end

  def image_large_path
    object.image_url :large
  end

  def image_small_path
    object.image_url :small
  end
  
end