require "rails_helper"

RSpec.describe Usman::Api::V1::RegistrationsController, :type => :request do  

  let(:country) {FactoryGirl.create(:country)}
  let(:city) {FactoryGirl.create(:city, country: country)}

  describe "create_profile" do
    context "Positive Case" do
      it "should create the profile" do
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: nil)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        user = FactoryGirl.build(:user)
        
        profile_data = {
                          name: user.name,
                          gender: user.gender,
                          date_of_birth: user.date_of_birth,
                          email: user.email,
                          country_id: country.id,
                          city_id: city.id
                        }

        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        post "/api/v1/create_profile", params: profile_data, headers: headers
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(true)

        expect(response_body["alert"]["heading"]).to eq("The Profile has been saved successfully")
        expect(response_body["alert"]["message"]).to eq("You may access the profile API with API token to get the profile details in future")

        data = response_body['data']

        user = reg.reload.user

        expect(data["user"]["id"]).to eq(user.id)
        expect(data["user"]["name"]).to eq(user.name)
        expect(data["user"]["username"]).to eq(user.username)
        expect(data["user"]["email"]).to eq(user.email)
        expect(data["user"]["phone"]).to eq(user.phone.to_s)
      end
    end
    context 'Negative Cases' do
      it "should set proper errors if api token is not present" do
        user = FactoryGirl.create(:user)
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: user)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        profile_data = {
                          name: user.name,
                          gender: user.gender,
                          date_of_birth: user.date_of_birth,
                          email: user.email,
                          country_id: country.id,
                          city_id: city.id
                        }

        post "/api/v1/create_profile", params: profile_data
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(false)
        expect(response_body["alert"]).to be_blank
        expect(response_body["data"]).to be_blank

        expect(response_body["errors"]["heading"]).to eq("Invalid API Token")
        expect(response_body["errors"]["message"]).to eq("Use the API Token you have received after accepting the terms and agreement")

        data = response_body['data']
      end

      it "should set proper errors if the profile already exists" do
        user = FactoryGirl.create(:user)
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: user)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        profile_data = {
                          name: user.name,
                          gender: user.gender,
                          date_of_birth: user.date_of_birth,
                          email: user.email,
                          country_id: country.id,
                          city_id: city.id
                        }

        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        post "/api/v1/create_profile", params: profile_data, headers: headers
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(false)
        expect(response_body["alert"]).to be_blank
        expect(response_body["data"]).to be_blank

        expect(response_body["errors"]["heading"]).to eq("A profile already exists for the mobile number you have provided")
        expect(response_body["errors"]["message"]).to eq("You are trying to create a profile once again when you already have a profile. Use Profile API with your API Token, to get your profile details and use them instead of creating a new one.")

        data = response_body['data']
      end

      it "should set proper errors if the inputs are not correct" do
        user = FactoryGirl.build(:user)
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: nil)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        profile_data = {}

        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        post "/api/v1/create_profile", params: profile_data, headers: headers
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(false)
        expect(response_body["alert"]).to be_blank
        expect(response_body["data"]).to be_blank

        expect(response_body["errors"]["heading"]).to eq("Saving Profile Failed")
        expect(response_body["errors"]["message"]).to eq("Check if all mandatory details are passed. Refer the error details for technical information")
        expect(response_body["errors"]["details"]["name"]).not_to be_blank
        expect(response_body["errors"]["details"]["email"]).not_to be_blank
      end
    end
  end

  describe "update_profile" do
    context "Positive Case" do
      it "should update the profile" do
        user = FactoryGirl.create(:user)
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: user)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        profile_data = {
                          name: user.name,
                          gender: user.gender,
                          date_of_birth: user.date_of_birth,
                          email: user.email,
                          country_id: country.id,
                          city_id: city.id
                        }

        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        post "/api/v1/update_profile", params: profile_data, headers: headers
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(true)

        expect(response_body["alert"]["heading"]).to eq("The Profile has been saved successfully")
        expect(response_body["alert"]["message"]).to eq("You may access the profile API with API token to get the profile details in future")

        data = response_body['data']

        user = reg.reload.user

        expect(data["user"]["id"]).to eq(user.id)
        expect(data["user"]["name"]).to eq(user.name)
        expect(data["user"]["username"]).to eq(user.username)
        expect(data["user"]["email"]).to eq(user.email)
        expect(data["user"]["phone"]).to eq(user.phone.to_s)
      end
    end
    context 'Negative Cases' do
      it "should set proper errors if api token is not present" do
        user = FactoryGirl.create(:user)
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: user)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        profile_data = {
                          name: user.name,
                          gender: user.gender,
                          date_of_birth: user.date_of_birth,
                          email: user.email,
                          country_id: country.id,
                          city_id: city.id
                        }

        post "/api/v1/update_profile", params: profile_data
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(false)
        expect(response_body["alert"]).to be_blank
        expect(response_body["data"]).to be_blank

        expect(response_body["errors"]["heading"]).to eq("Invalid API Token")
        expect(response_body["errors"]["message"]).to eq("Use the API Token you have received after accepting the terms and agreement")

        data = response_body['data']
      end

      it "should set proper errors if the already profile didn't exist" do
        
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: nil)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        user = FactoryGirl.build(:user)

        profile_data = {
                          name: user.name,
                          gender: user.gender,
                          date_of_birth: user.date_of_birth,
                          email: user.email,
                          country_id: country.id,
                          city_id: city.id
                        }

        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        post "/api/v1/update_profile", params: profile_data, headers: headers
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(false)
        expect(response_body["alert"]).to be_blank
        expect(response_body["data"]).to be_blank

        expect(response_body["errors"]["heading"]).to eq("Profile doesn't exists for the mobile number you have provided")
        expect(response_body["errors"]["message"]).to eq("You are trying to create a profile once again when you already have a profile. Use Profile API with your API Token, to get your profile details and use them instead of creating a new one.")

        data = response_body['data']
      end

      it "should set proper errors if the inputs are not correct" do
        user = FactoryGirl.build(:user)
        reg = FactoryGirl.create(:verified_registration, country: country, city: city, user: user)
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        profile_data = {}

        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        post "/api/v1/update_profile", params: profile_data, headers: headers
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(false)
        expect(response_body["alert"]).to be_blank
        expect(response_body["data"]).to be_blank

        expect(response_body["errors"]["heading"]).to eq("Saving Profile Failed")
        expect(response_body["errors"]["message"]).to eq("Check if all mandatory details are passed. Refer the error details for technical information")
        expect(response_body["errors"]["details"]["name"]).not_to be_blank
        expect(response_body["errors"]["details"]["email"]).not_to be_blank
      end
    end
  end

end