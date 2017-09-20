require 'spec_helper'

RSpec.describe ProfileSerializer, type: :serializer do

  describe "attributes" do
    it "should include profile attributes" do
      nayan = FactoryGirl.create(:user, name: "Nayan Tara")
  
      json_data = ActiveModelSerializers::SerializableResource.new(nayan, serializer: ProfileSerializer).to_json
      data = JSON.parse(json_data)

      expect(data["id"]).to eq(nayan.id)
      expect(data["name"]).to eq("Nayan Tara")
      expect(data["gender"]).to eq("male")
      expect(data["date_of_birth"]).to eq("1980-01-01")
      expect(data["username"]).to eq(nayan.username)
      expect(data["email"]).to eq(nayan.email)
      expect(data["phone"]).to eq(nayan.phone)
    end
  end
  
  
end