require 'spec_helper'

RSpec.describe RegistrationSerializer, type: :serializer do

  describe "attributes" do
    it "should include registration and profile attributes - if it is a dummy user" do
      reg = FactoryBot.create(:verified_registration, city: nil)
      reg.user = User.new(dummy: true)
      reg.user.generate_dummy_data(reg)
      reg.user.save

      json_data = ActiveModelSerializers::SerializableResource.new(reg, serializer: RegistrationSerializer).to_json
      data = JSON.parse(json_data)

      expect(data["id"]).to eq(reg.id)
      expect(data["dialing_prefix"]).to eq(reg.dialing_prefix)
      expect(data["mobile_number"]).to eq(reg.mobile_number)
      expect(data["status"]).to eq(reg.status)
      expect(data["user_id"]).to eq(reg.user_id)
      expect(data["country_id"]).to eq(reg.country_id)
      expect(data["city_id"]).to be_blank
      
      expect(data["user"]["id"]).to eq(reg.user.id)
      expect(data["user"]["name"]).to eq(reg.user.name)
      expect(data["user"]["gender"]).to be_blank
      expect(data["user"]["date_of_birth"]).to be_blank
      expect(data["user"]["username"]).to eq(reg.user.username)
      expect(data["user"]["email"]).to eq(reg.user.email)
      expect(data["user"]["phone"]).to be_blank
      expect(data["user"]["dummy"]).to be_truthy
      expect(data["user"]["country_id"]).to eq(reg.user.country_id)
      expect(data["user"]["city_id"]).to be_blank

      expect(data["country"]["id"]).to eq(reg.country.id)
      expect(data["country"]["name"]).to eq(reg.country.name)
      expect(data["country"]["iso_name"]).to eq(reg.country.iso_name)
      expect(data["country"]["dialing_prefix"]).to eq(reg.country.dialing_prefix)
      expect(data["country"]["priority"]).to eq(reg.country.priority)

      expect(data["city"]["id"]).to be_blank
      expect(data["city"]["name"]).to be_blank
      expect(data["city"]["priority"]).not_to be_blank
      expect(data["city"]["operational"]).to be_falsy
      
    end

    it "should include profile attributes with profile picture" do
      reg = FactoryBot.create(:verified_registration)
      nayan = FactoryBot.create(:user, name: "Nayan Tara", gender: "female")
      profile_picture = FactoryBot.create(:profile_picture, imageable: nayan)
      reg.user = nayan
      reg.save

      json_data = ActiveModelSerializers::SerializableResource.new(reg, serializer: RegistrationSerializer).to_json
      data = JSON.parse(json_data)

      expect(data["id"]).to eq(reg.id)
      expect(data["dialing_prefix"]).to eq(reg.dialing_prefix)
      expect(data["mobile_number"]).to eq(reg.mobile_number)
      expect(data["status"]).to eq(reg.status)
      expect(data["user_id"]).to eq(reg.user_id)
      expect(data["country_id"]).to eq(reg.country_id)
      expect(data["city_id"]).to eq(reg.city_id)
      
      expect(data["user"]["id"]).to eq(nayan.id)
      expect(data["user"]["name"]).to eq(nayan.name)
      expect(data["user"]["gender"]).to eq(nayan.gender)
      expect(data["user"]["date_of_birth"]).to eq(nayan.date_of_birth.strftime('%d-%m-%Y'))
      expect(data["user"]["username"]).to eq(nayan.username)
      expect(data["user"]["email"]).to eq(nayan.email)
      expect(data["user"]["phone"]).to eq(nayan.phone)
      expect(data["user"]["dummy"]).to be_falsy

      expect(data["country"]["id"]).to eq(reg.country.id)
      expect(data["country"]["name"]).to eq(reg.country.name)
      expect(data["country"]["iso_name"]).to eq(reg.country.iso_name)
      expect(data["country"]["dialing_prefix"]).to eq(reg.country.dialing_prefix)
      expect(data["country"]["priority"]).to eq(reg.country.priority)

      expect(data["city"]["id"]).to eq(reg.city.id)
      expect(data["city"]["name"]).to eq(reg.city.name)
      expect(data["city"]["priority"]).to eq(reg.city.priority)
      expect(data["city"]["operational"]).to be_falsy      
    end
  end
  
  
end