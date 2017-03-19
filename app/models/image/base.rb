class Image::Base < ActiveRecord::Base

  self.table_name = "images"

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  # Associations
  belongs_to :imageable, :polymorphic => true, optional: true

  # Callbacks
  after_save :crop_image

  def crop_image
    image.recreate_versions! if crop_x.present?
  end

  #one convenient method to pass jq_upload the necessary information
  def to_jq_upload
    {
      "name" => read_attribute(:image),
      "size" => image.size,
      "original_url" => image.url,
      "large_url" => image.large.url,
      "medium_url" => image.medium.url,
      "small_url" => image.small.url,
      "tiny_url" => image.tiny.url
    }
  end

end
