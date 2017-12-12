require "rails_helper"

RSpec.describe Usman::Api::V1::ContactsController, :type => :request do  

  let(:country) {FactoryGirl.create(:country)}
  let(:region) {FactoryGirl.create(:region, country: country)}
  let(:city) {FactoryGirl.create(:city, region: region)}

  describe "sync" do
    context "Positive Case" do
      it "should sync all the new contacts and return empty array" do
        user = FactoryGirl.create(:approved_user, country: country, city: city)
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: user)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        contact_1 = FactoryGirl.build(:contact, name: "Lalettan", email: "mohanlal@mollywood.com", account_type: "com.mollywood", contact_number: "+919880123123", )
        contact_2 = FactoryGirl.build(:contact, name: "Mammukka", email: "mammotty@mollywood.com", account_type: "com.mollywood", contact_number: "+919880456456", )
        contact_3 = FactoryGirl.build(:contact, name: "Ambili Chettan", email: nil, account_type: "com.mollywood", contact_number: "1345345345", )
        contact_4 = FactoryGirl.build(:contact, name: "Shobhana", email: "shobhana@mollywood.com", account_type: "com.mollywood", contact_number: "+919880789789", )
        contact_5 = FactoryGirl.build(:contact, name: "Seetha", email: nil, account_type: "com.mollywood", contact_number: "1345345345", )
        
        contacts_data = [
                          {
                            name: contact_1.name,
                            account_type: contact_1.account_type,
                            email: contact_1.email,
                            address: contact_1.address,
                            contact_number: contact_1.contact_number
                          },
                          {
                            name: contact_2.name,
                            account_type: contact_2.account_type,
                            email: contact_2.email,
                            address: contact_2.address,
                            contact_number: contact_2.contact_number
                          }
                        ]

        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        post "/api/v1/contacts/sync", params: {contacts: contacts_data}, headers: headers
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(true)

        expect(response_body["alert"]["heading"]).to eq("The Contacts has been synced successfully")
        expect(response_body["alert"]["message"]).to eq("You may now store the done deal user id of these contacts returned in this response")

        data = response_body['data']
        expect(data).to be_blank
      end

      it "should sync all the new contacts and return contacts who have already joined done deal" do

        mohanlal = FactoryGirl.create(:user, name: "Mohanlal")
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: mohanlal, dialing_prefix: "+91", mobile_number: "9880123123")
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        mammotty = FactoryGirl.create(:user, name: "Mammotty")
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: mammotty, dialing_prefix: "+92", mobile_number: "9880123123")
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        shobhana = FactoryGirl.create(:user, name: "Shobhana")
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: shobhana, dialing_prefix: "+93", mobile_number: "9880123123")
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)

        seetha = FactoryGirl.create(:user, name: "Seetha")
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: seetha, dialing_prefix: "+94", mobile_number: "9880123123")
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        contact_1 = FactoryGirl.build(:contact, name: "Lalettan", email: "mohanlal@mollywood.com", account_type: "com.mollywood", contact_number: "+919880123123")
        contact_2 = FactoryGirl.build(:contact, name: "Mammukka", email: "mammotty@mollywood.com", account_type: "com.mollywood", contact_number: "+929880123123")
        contact_3 = FactoryGirl.build(:contact, name: "Ambili Chettan", email: "jagathy@mollywood.com", account_type: "com.mollywood", contact_number: "1345345345")
        contact_4 = FactoryGirl.build(:contact, name: "Shobhana", email: "shobhana@mollywood.com", account_type: "com.mollywood", contact_number: "+939880123123")
        contact_5 = FactoryGirl.build(:contact, name: "Seetha", email: "seetha@mollywood.com", account_type: "com.mollywood", contact_number: "+949880123123")

        user = FactoryGirl.create(:approved_user, country: country, city: city)
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: user)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)

        contacts_data = [
                          {
                            name: contact_1.name,
                            account_type: contact_1.account_type,
                            email: contact_1.email,
                            address: contact_1.address,
                            contact_number: contact_1.contact_number
                          },
                          {
                            name: contact_2.name,
                            account_type: contact_2.account_type,
                            email: contact_2.email,
                            address: contact_2.address,
                            contact_number: contact_2.contact_number
                          },
                          {
                            name: contact_3.name,
                            account_type: contact_3.account_type,
                            email: contact_3.email,
                            address: contact_3.address,
                            contact_number: contact_3.contact_number
                          },
                          {
                            name: contact_4.name,
                            account_type: contact_4.account_type,
                            email: contact_4.email,
                            address: contact_4.address,
                            contact_number: contact_4.contact_number
                          },
                          {
                            name: contact_5.name,
                            account_type: contact_5.account_type,
                            email: contact_5.email,
                            address: contact_5.address,
                            contact_number: contact_5.contact_number
                          }
                        ]

        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        post "/api/v1/contacts/sync", params: {contacts: contacts_data}, headers: headers
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)
        data = response_body['data']
        
        expect(response_body["success"]).to eq(true)
        expect(data).not_to be_blank

        expect(response_body["alert"]["heading"]).to eq("The Contacts has been synced successfully")
        expect(response_body["alert"]["message"]).to eq("You may now store the done deal user id of these contacts returned in this response")

        expect(data[0]["id"]).not_to be_blank
        expect(data[0]["name"]).to eq(contact_1.name.to_s)
        expect(data[0]["account_type"]).to eq(contact_1.account_type.to_s)
        expect(data[0]["email"]).to eq(contact_1.email.to_s)
        expect(data[0]["contact_number"]).to eq(contact_1.contact_number.to_s)
        # expect(data[0]["user_id"]).to eq(user.id)

        expect(data[1]["id"]).not_to be_blank
        expect(data[1]["name"]).to eq(contact_2.name.to_s)
        expect(data[1]["account_type"]).to eq(contact_2.account_type.to_s)
        expect(data[1]["email"]).to eq(contact_2.email.to_s)
        expect(data[1]["contact_number"]).to eq(contact_2.contact_number.to_s)
        
        expect(data[2]["id"]).not_to be_blank
        expect(data[2]["name"]).to eq(contact_4.name.to_s)
        expect(data[2]["account_type"]).to eq(contact_4.account_type.to_s)
        expect(data[2]["email"]).to eq(contact_4.email.to_s)
        expect(data[2]["contact_number"]).to eq(contact_4.contact_number.to_s)
        
        expect(data[3]["id"]).not_to be_blank
        expect(data[3]["name"]).to eq(contact_5.name.to_s)
        expect(data[3]["account_type"]).to eq(contact_5.account_type.to_s)
        expect(data[3]["email"]).to eq(contact_5.email.to_s)
        expect(data[3]["contact_number"]).to eq(contact_5.contact_number.to_s)
      end
    end

    context 'Negative Cases' do
      it "should set proper errors if api token is not present" do
        contacts_data = {}
        post "/api/v1/contacts/sync", params: contacts_data
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(false)
        expect(response_body["alert"]).to be_blank
        expect(response_body["data"]).to be_blank

        expect(response_body["errors"]["heading"]).to eq("Invalid API Token")
        expect(response_body["errors"]["message"]).to eq("Use the API Token you have received after accepting the terms and agreement")

        data = response_body['data']
      end
    end
  end

  describe "index" do
    context "Positive Case" do
      it "should return a list of contacts of a user" do
        user = FactoryGirl.create(:approved_user, country: country, city: city)
        
        # User Mohanlal
        mohanlal = FactoryGirl.create(:approved_user, country: country, city: city)
        profile_picture = FactoryGirl.create(:profile_picture, imageable: mohanlal)
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: mohanlal)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)

        # User Mammotty
        mammotty = FactoryGirl.create(:approved_user, country: country, city: city)
        profile_picture = FactoryGirl.create(:profile_picture, imageable: mammotty)
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: mammotty)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        # Contacts for Mohanlal and Mammotty
        mohanlal_contact = FactoryGirl.create(:contact, name: "Lalettan", done_deal_user: mohanlal, owner: user, email: "mohanlal@mollywood.com")
        mammotty_contact = FactoryGirl.create(:contact, name: "Mammukka", done_deal_user: mammotty, owner: user, email: "mammotty@mollywood.com")

        # Current User
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: user)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex, user: user)
        
        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        get "/api/v1/contacts", headers: headers
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)
        
        expect(response_body["success"]).to eq(true)

        data = response_body['data']

        expect(data[0]["id"]).to eq(mohanlal_contact.id)
        expect(data[0]["name"]).to eq(mohanlal_contact.name)
        expect(data[0]["account_type"]).to eq(mohanlal_contact.account_type.to_s)
        expect(data[0]["email"]).to eq(mohanlal_contact.email.to_s)
        expect(data[0]["address"]).to eq(mohanlal_contact.address.to_s)
        expect(data[0]["contact_number"]).to eq(mohanlal_contact.contact_number.to_s)
        
        profile_picture = mohanlal.profile_picture

        expect(data[0]["profile_picture"]["id"]).to eq(profile_picture.id)
        expect(data[0]["profile_picture"]["profile_id"]).to eq(mohanlal.id)
        expect(data[0]["profile_picture"]["created_at"]).to eq(profile_picture.created_at.strftime('%d-%m-%Y %H:%M:%S'))
        expect(data[0]["profile_picture"]["image_large_path"]).not_to be_blank
        expect(data[0]["profile_picture"]["image_small_path"]).not_to be_blank


        expect(data[1]["id"]).to eq(mammotty_contact.id)
        expect(data[1]["name"]).to eq(mammotty_contact.name)
        expect(data[1]["account_type"]).to eq(mammotty_contact.account_type.to_s)
        expect(data[1]["email"]).to eq(mammotty_contact.email.to_s)
        expect(data[1]["address"]).to eq(mammotty_contact.address.to_s)
        expect(data[1]["contact_number"]).to eq(mammotty_contact.contact_number.to_s)
        
        profile_picture = mammotty.profile_picture

        expect(data[1]["profile_picture"]["id"]).to eq(profile_picture.id)
        expect(data[1]["profile_picture"]["profile_id"]).to eq(mammotty.id)
        expect(data[1]["profile_picture"]["created_at"]).to eq(profile_picture.created_at.strftime('%d-%m-%Y %H:%M:%S'))
        expect(data[1]["profile_picture"]["image_large_path"]).not_to be_blank
        expect(data[1]["profile_picture"]["image_small_path"]).not_to be_blank
      end

      it "should return the individual contact for a user - contact has not joined and doesn't have a profile picture" do
        user = FactoryGirl.create(:approved_user, country: country, city: city)
        
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: user)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex, user: user)

        mohanlal_contact = FactoryGirl.create(:contact, name: "Lalettan", owner: user)
        
        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        get "/api/v1/contacts/#{mohanlal_contact.id}", headers: headers
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)
        
        expect(response_body["success"]).to eq(true)

        data = response_body['data']

        expect(data["id"]).to eq(mohanlal_contact.id)
        expect(data["name"]).to eq(mohanlal_contact.name)
        expect(data["account_type"]).to eq(mohanlal_contact.account_type.to_s)
        expect(data["email"]).to eq(mohanlal_contact.email.to_s)
        expect(data["address"]).to eq(mohanlal_contact.address.to_s)
        expect(data["contact_number"]).to eq(mohanlal_contact.contact_number.to_s)

        expect(data["profile_picture"]["id"]).to eq("")
        expect(data["profile_picture"]["created_at"]).to eq("")
        expect(data["profile_picture"]["profile_id"]).to eq("")
        expect(data["profile_picture"]["image_large_path"]).to be_blank
        expect(data["profile_picture"]["image_small_path"]).to be_blank
      end
    end
    context 'Negative Cases' do
      it "should set proper errors if api token is not present" do
        user = FactoryGirl.create(:approved_user, country: country, city: city)
        
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: user)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex, user: user)

        mohanlal_contact = FactoryGirl.create(:contact, name: "Lalettan", owner: user)
        
        get "/api/v1/contacts/#{mohanlal_contact.id}"
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(false)
        expect(response_body["alert"]).to be_blank
        expect(response_body["data"]).to be_blank

        expect(response_body["errors"]["heading"]).to eq("Invalid API Token")
        expect(response_body["errors"]["message"]).to eq("Use the API Token you have received after accepting the terms and agreement")

        data = response_body['data']
      end

      it "should set proper errors if the profile didn't exist" do
        
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: nil)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)

        user = FactoryGirl.build(:user)

        mohanlal_contact = FactoryGirl.create(:contact, name: "Lalettan", owner: user)

        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        get "/api/v1/contacts/#{mohanlal_contact.id}", headers: headers
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(false)
        expect(response_body["alert"]).to be_blank
        expect(response_body["data"]).to be_blank

        expect(response_body["errors"]["heading"]).to eq("Profile doesn't exists for the mobile number you have provided")
        expect(response_body["errors"]["message"]).to eq("You are trying to create a profile once again when you already have a profile. Use Profile API with your API Token, to get your profile details and use them instead of creating a new one.")

        data = response_body['data']
      end
    end
  end

  describe "show" do
    context "Positive Case" do
      it "should return the individual contact for a user - contact has joined and has a profile picture" do
        user = FactoryGirl.create(:approved_user, country: country, city: city)
        
        mohanlal = FactoryGirl.create(:approved_user, country: country, city: city)
        profile_picture = FactoryGirl.create(:profile_picture, imageable: mohanlal)
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: mohanlal)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: user)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex, user: user)

        mohanlal_contact = FactoryGirl.create(:contact, name: "Lalettan", done_deal_user: mohanlal, owner: user)
        
        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        get "/api/v1/contacts/#{mohanlal_contact.id}", headers: headers
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)
        
        expect(response_body["success"]).to eq(true)

        data = response_body['data']

        expect(data["id"]).to eq(mohanlal_contact.id)
        expect(data["name"]).to eq(mohanlal_contact.name)
        expect(data["account_type"]).to eq(mohanlal_contact.account_type.to_s)
        expect(data["email"]).to eq(mohanlal_contact.email.to_s)
        expect(data["address"]).to eq(mohanlal_contact.address.to_s)
        expect(data["contact_number"]).to eq(mohanlal_contact.contact_number.to_s)
        
        profile_picture = mohanlal.profile_picture

        expect(data["profile_picture"]["id"]).to eq(profile_picture.id)
        expect(data["profile_picture"]["profile_id"]).to eq(mohanlal.id)
        expect(data["profile_picture"]["created_at"]).to eq(profile_picture.created_at.strftime('%d-%m-%Y %H:%M:%S'))
        expect(data["profile_picture"]["image_large_path"]).not_to be_blank
        expect(data["profile_picture"]["image_small_path"]).not_to be_blank
      end

      it "should return the individual contact for a user - contact has not joined and doesn't have a profile picture" do
        user = FactoryGirl.create(:approved_user, country: country, city: city)
        
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: user)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex, user: user)

        mohanlal_contact = FactoryGirl.create(:contact, name: "Lalettan", owner: user)
        
        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        get "/api/v1/contacts/#{mohanlal_contact.id}", headers: headers
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)
        
        expect(response_body["success"]).to eq(true)

        data = response_body['data']

        expect(data["id"]).to eq(mohanlal_contact.id)
        expect(data["name"]).to eq(mohanlal_contact.name)
        expect(data["account_type"]).to eq(mohanlal_contact.account_type.to_s)
        expect(data["email"]).to eq(mohanlal_contact.email.to_s)
        expect(data["address"]).to eq(mohanlal_contact.address.to_s)
        expect(data["contact_number"]).to eq(mohanlal_contact.contact_number.to_s)
        
        expect(data["profile_picture"]["id"]).to eq("")
        expect(data["profile_picture"]["created_at"]).to eq("")
        expect(data["profile_picture"]["profile_id"]).to eq("")
        expect(data["profile_picture"]["image_large_path"]).to be_blank
        expect(data["profile_picture"]["image_small_path"]).to be_blank
      end
    end
    context 'Negative Cases' do
      it "should set proper errors if api token is not present" do
        user = FactoryGirl.create(:approved_user, country: country, city: city)
        
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: user)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex, user: user)

        mohanlal_contact = FactoryGirl.create(:contact, name: "Lalettan", owner: user)
        
        get "/api/v1/contacts/#{mohanlal_contact.id}"
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(false)
        expect(response_body["alert"]).to be_blank
        expect(response_body["data"]).to be_blank

        expect(response_body["errors"]["heading"]).to eq("Invalid API Token")
        expect(response_body["errors"]["message"]).to eq("Use the API Token you have received after accepting the terms and agreement")

        data = response_body['data']
      end

      it "should set proper errors if the profile didn't exist" do
        
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: nil)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)

        user = FactoryGirl.build(:user)

        mohanlal_contact = FactoryGirl.create(:contact, name: "Lalettan", owner: user)

        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        get "/api/v1/contacts/#{mohanlal_contact.id}", headers: headers
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(false)
        expect(response_body["alert"]).to be_blank
        expect(response_body["data"]).to be_blank

        expect(response_body["errors"]["heading"]).to eq("Profile doesn't exists for the mobile number you have provided")
        expect(response_body["errors"]["message"]).to eq("You are trying to create a profile once again when you already have a profile. Use Profile API with your API Token, to get your profile details and use them instead of creating a new one.")

        data = response_body['data']
      end
    end
  end

end