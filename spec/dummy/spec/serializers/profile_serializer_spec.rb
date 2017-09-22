require 'spec_helper'

RSpec.describe ProfileSerializer, type: :serializer do

  describe "attributes" do
    it "should include profile attributes" do
      nayan = FactoryGirl.create(:user, name: "Nayan Tara")
      profile_picture = FactoryGirl.create(:profile_picture, imageable: nayan)
  
      json_data = ActiveModelSerializers::SerializableResource.new(nayan, serializer: ProfileSerializer).to_json
      data = JSON.parse(json_data)

      expect(data["id"]).to eq(nayan.id)
      expect(data["name"]).to eq("Nayan Tara")
      expect(data["gender"]).to eq("male")
      expect(data["date_of_birth"]).to eq(nayan.date_of_birth.strftime('%d-%m-%Y'))
      expect(data["username"]).to eq(nayan.username)
      expect(data["email"]).to eq(nayan.email)
      expect(data["phone"]).to eq(nayan.phone)

      expect(data["profile_picture"]["id"]).to eq(profile_picture.id)
      expect(data["profile_picture"]["profile_id"]).to eq(nayan.id)
      expect(data["profile_picture"]["created_at"]).to eq(profile_picture.created_at.strftime('%d-%m-%Y %H:%M:%S'))
      expect(data["profile_picture"]["image_large_path"]).not_to be_blank
      expect(data["profile_picture"]["image_small_path"]).not_to be_blank
      
    end
  end
  
  
end