require 'spec_helper'

RSpec.describe OwnerSerializer, type: :sOwnererializer do

  describe "attributes" do
    it "should render the user object with profile attributes and registration" do
      nayan = FactoryGirl.create(:user, name: "Nayan Tara")
      profile_picture = FactoryGirl.create(:profile_picture, imageable: nayan)
      reg = FactoryGirl.create(:registration, user: nayan)
    
      json_data = ActiveModelSerializers::SerializableResource.new(nayan, serializer: OwnerSerializer).to_json
      data = JSON.parse(json_data)

      expect(data["id"]).to eq(nayan.id)
      expect(data["name"]).to eq("Nayan Tara")
      expect(data["email"]).to eq(nayan.email)
      expect(data["registration"]["id"]).to eq(reg.id)
      expect(data["registration"]["status"]).to eq(reg.status)
      expect(data["registration"]["dialing_prefix"]).to eq(reg.dialing_prefix)
      expect(data["registration"]["mobile_number"]).to eq(reg.mobile_number)

      expect(data["profile_picture"]["id"]).to eq(profile_picture.id)
      expect(data["profile_picture"]["profile_id"]).to eq(nayan.id)
      expect(data["profile_picture"]["created_at"]).to eq(profile_picture.created_at.strftime('%d-%m-%Y %H:%M:%S'))
      expect(data["profile_picture"]["image_large_path"]).not_to be_blank
      expect(data["profile_picture"]["image_small_path"]).not_to be_blank
    end
    it "should render the user object without profile attributes and registration" do
      nayan = FactoryGirl.create(:user, name: "Nayan Tara")
      
      json_data = ActiveModelSerializers::SerializableResource.new(nayan, serializer: OwnerSerializer).to_json
      data = JSON.parse(json_data)

      expect(data["id"]).to eq(nayan.id)
      expect(data["name"]).to eq("Nayan Tara")
      expect(data["email"]).to eq(nayan.email)
      expect(data["registration_dialing_prefix"]).to be_blank
      expect(data["registration_mobile_number"]).to be_blank

      expect(data["profile_picture"]["id"]).to eq("")
      expect(data["profile_picture"]["profile_id"]).to eq(nayan.id)
      expect(data["profile_picture"]["created_at"]).to eq("")
      expect(data["profile_picture"]["image_large_path"]).to be_blank
      expect(data["profile_picture"]["image_small_path"]).to be_blank
    end
  end
  
  
end