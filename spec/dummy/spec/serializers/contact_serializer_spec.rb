require 'spec_helper'

RSpec.describe ContactSerializer, type: :serializer do

  describe "attributes" do
    it "should include contact attributes with empty profile picture" do
      nayan = FactoryGirl.create(:user, name: "Nayan Tara")
      reg = FactoryGirl.create(:verified_registration, user: nayan)
      dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)

      contact = FactoryGirl.create(:contact, name: "Nayan", email: "nayan@mollywood.com", account_type: "com.mollywood", contact_number_2: "1234234234", contact_number_2: "2234234234", contact_number_3: "3234234234", contact_number_4: "4234234234", done_deal_user: nayan)
      # profile_picture = FactoryGirl.create(:profile_picture, imageable: nayan)
  
      json_data = ActiveModelSerializers::SerializableResource.new(contact, serializer: ContactSerializer).to_json
      data = JSON.parse(json_data)

      expect(data["id"]).to eq(contact.id)
      expect(data["name"]).to eq(contact.name)
      expect(data["account_type"]).to eq(contact.account_type)

      expect(data["email"]).to eq(contact.email.to_s)
      expect(data["address"]).to eq(contact.address.to_s)

      expect(data["contact_number"]).to eq(contact.contact_number)
      
      expect(data["profile_picture"]["id"]).to be_blank
      expect(data["profile_picture"]["profile_id"]).to be_blank
      expect(data["profile_picture"]["created_at"]).to be_blank
      expect(data["profile_picture"]["image_large_path"]).to be_blank
      expect(data["profile_picture"]["image_small_path"]).to be_blank
    end

    it "should include profile attributes with profile picture" do
      nayan = FactoryGirl.create(:user, name: "Nayan Tara")
      reg = FactoryGirl.create(:verified_registration, user: nayan)
      dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)

      contact = FactoryGirl.create(:contact, name: "Nayan", email: "nayan@mollywood.com", account_type: "com.mollywood", contact_number_2: "1234234234", contact_number_2: "2234234234", contact_number_3: "3234234234", contact_number_4: "4234234234", done_deal_user: nayan)
      profile_picture = FactoryGirl.create(:profile_picture, imageable: nayan)
  
      json_data = ActiveModelSerializers::SerializableResource.new(contact, serializer: ContactSerializer).to_json
      data = JSON.parse(json_data)

      expect(data["id"]).to eq(contact.id)
      expect(data["name"]).to eq(contact.name)
      expect(data["account_type"]).to eq(contact.account_type)

      expect(data["email"]).to eq(contact.email.to_s)
      expect(data["address"]).to eq(contact.address.to_s)

      expect(data["contact_number"]).to eq(contact.contact_number)
      
      expect(data["profile_picture"]["id"]).to eq(profile_picture.id)
      expect(data["profile_picture"]["profile_id"]).to eq(nayan.id)
      expect(data["profile_picture"]["created_at"]).to eq(profile_picture.created_at.strftime('%d-%m-%Y %H:%M:%S'))
      expect(data["profile_picture"]["image_large_path"]).not_to be_blank
      expect(data["profile_picture"]["image_small_path"]).not_to be_blank
    end
  end
end