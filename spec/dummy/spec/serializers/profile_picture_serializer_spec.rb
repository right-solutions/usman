require 'rails_helper'

RSpec.describe ProfilePictureSerializer, type: :serializer do
  describe "attributes" do
    it "should include image attributes" do
      profile_picture = FactoryGirl.create(:profile_picture)

      json_data = ActiveModelSerializers::SerializableResource.new(profile_picture, serializer: ProfilePictureSerializer).to_json
      data = JSON.parse(json_data)

      expect(data["id"]).to eq(profile_picture.id)
      expect(data["profile_id"]).to eq(profile_picture.imageable_id)
      expect(data["created_at"]).to eq(profile_picture.created_at.strftime('%d-%m-%Y %H:%M:%S'))
      expect(data["image_large_path"]).not_to be_blank
      expect(data["image_small_path"]).not_to be_blank
    end
  end
end