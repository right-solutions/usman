require "rails_helper"

RSpec.describe Usman::Api::V1::RegistrationsController, :type => :request do  
  let(:india) {FactoryBot.create(:country, name: "India")}
  let(:kerala) {FactoryBot.create(:region, country: india, name: "Kerala")}
  let(:cochin) {FactoryBot.create(:city, region: kerala, name: "Cochin")}
  
  let(:uae) {FactoryBot.create(:country, name: "United Arab Emirates")}
  let(:dubai) {FactoryBot.create(:city, country: uae, name: "Dubai")}

  describe "create_profile" do
    context "Positive Case" do
      it "should create the profile" do
        reg = FactoryBot.create(:verified_registration, country: india, city: cochin, user: nil)
        dev = FactoryBot.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        user = FactoryBot.build(:user)
        
        profile_data = {
                          name: user.name,
                          gender: user.gender,
                          date_of_birth: user.date_of_birth,
                          email: user.email,
                          country_id: india.id,
                          city_id: cochin.id
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

        expect(user.approved?).to be_truthy

        expect(data["id"]).to eq(user.id)
        expect(data["name"]).to eq(user.name)
        
        expect(data["gender"]).to eq(user.gender)
        expect(data["date_of_birth"]).to eq(user.date_of_birth.strftime('%d-%m-%Y'))

        expect(data["username"]).to eq(user.username)
        expect(data["email"]).to eq(user.email)
        expect(data["phone"]).to eq(user.phone.to_s)

        expect(data["dummy"]).to be_falsy
        expect(data["country_id"]).to eq(india.id)
        expect(data["city_id"]).to eq(cochin.id)
      end

      it "should create the profile and save a profile picture" do
        reg = FactoryBot.create(:verified_registration, country: india, city: cochin, user: nil)
        dev = FactoryBot.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        user = FactoryBot.build(:user)
        
        profile_data = {
                          name: user.name,
                          gender: user.gender,
                          date_of_birth: user.date_of_birth,
                          email: user.email,
                          country_id: india.id,
                          city_id: cochin.id,
                          image: fixture_file_upload('spec/dummy/spec/factories/test.jpeg', 'image.jpeg')
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

        expect(user.approved?).to be_truthy

        expect(data["id"]).to eq(user.id)
        expect(data["name"]).to eq(user.name)
        
        expect(data["gender"]).to eq(user.gender)
        expect(data["date_of_birth"]).to eq(user.date_of_birth.strftime('%d-%m-%Y'))

        expect(data["username"]).to eq(user.username)
        expect(data["email"]).to eq(user.email)
        expect(data["phone"]).to eq(user.phone.to_s)

        expect(data["dummy"]).to be_falsy
        expect(data["country_id"]).to eq(india.id)
        expect(data["city_id"]).to eq(cochin.id)

        profile_picture = user.profile_picture

        # Checking if the profile picture has uploaded correctly
        expect(data["profile_picture"]["id"]).to eq(profile_picture.id)
        expect(data["profile_picture"]["created_at"]).to eq(profile_picture.created_at.strftime('%d-%m-%Y %H:%M:%S'))
        expect(data["profile_picture"]["profile_id"]).to eq(user.id)
        expect(data["profile_picture"]["image_large_path"]).not_to be_blank
        expect(data["profile_picture"]["image_small_path"]).not_to be_blank
        
      end

      it "should create the profile even if profile picture is invalid" do
        reg = FactoryBot.create(:verified_registration, country: india, city: cochin, user: nil)
        dev = FactoryBot.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        user = FactoryBot.build(:user)
        
        profile_data = {
                          name: user.name,
                          gender: user.gender,
                          date_of_birth: user.date_of_birth,
                          email: user.email,
                          country_id: india.id,
                          city_id: cochin.id,
                          image: fixture_file_upload('spec/dummy/spec/factories/test.csv', '')
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

        expect(response_body["errors"]["heading"]).to eq("Saving user/profile image was failed")
        expect(response_body["errors"]["message"]).to eq("Make sure that the arguments are passed according to the API documentation. Please check the API Documentation for more details.")

        data = response_body['data']

        user = reg.reload.user

        expect(user.approved?).to be_truthy

        expect(data["id"]).to eq(user.id)
        expect(data["name"]).to eq(user.name)
        
        expect(data["gender"]).to eq(user.gender)
        expect(data["date_of_birth"]).to eq(user.date_of_birth.strftime('%d-%m-%Y'))

        expect(data["username"]).to eq(user.username)
        expect(data["email"]).to eq(user.email)
        expect(data["phone"]).to eq(user.phone.to_s)

        expect(data["dummy"]).to be_falsy
        expect(data["country_id"]).to eq(india.id)
        expect(data["city_id"]).to eq(cochin.id)

        # Checking if the profile picture has uploaded correctly
        expect(user.profile_picture).to be_blank
        expect(data["profile_picture"]["id"]).to eq("")
        expect(data["profile_picture"]["created_at"]).to eq("")
        expect(data["profile_picture"]["profile_id"]).to eq(user.id)
        expect(data["profile_picture"]["image_large_path"]).to be_blank
        expect(data["profile_picture"]["image_small_path"]).to be_blank
      end
    end
    context 'Negative Cases' do
      it "should set proper errors if api token is not present" do
        user = FactoryBot.create(:user)
        reg = FactoryBot.create(:verified_registration, country: india, city: cochin, user: user)
        dev = FactoryBot.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        profile_data = {
                          name: user.name,
                          gender: user.gender,
                          date_of_birth: user.date_of_birth,
                          email: user.email,
                          country_id: india.id,
                          city_id: cochin.id
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
        user = FactoryBot.create(:approved_user)
        reg = FactoryBot.create(:verified_registration, country: india, city: cochin, user: user)
        dev = FactoryBot.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        profile_data = {
                          name: user.name,
                          gender: user.gender,
                          date_of_birth: user.date_of_birth,
                          email: user.email,
                          country_id: india.id,
                          city_id: cochin.id
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
        user = FactoryBot.build(:user)
        reg = FactoryBot.create(:verified_registration, country: india, city: cochin, user: nil)
        dev = FactoryBot.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
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
        user = FactoryBot.create(:approved_user, dummy: true)
        profile_picture = FactoryBot.create(:profile_picture, imageable: user)

        reg = FactoryBot.create(:verified_registration, country: india, city: cochin, user: user)
        dev = FactoryBot.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        profile_data = {
                          name: user.name,
                          gender: user.gender,
                          date_of_birth: user.date_of_birth,
                          email: user.email,
                          country_id: uae.id,
                          city_id: dubai.id
                        }

        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        put "/api/v1/update_profile", params: profile_data, headers: headers
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(true)

        expect(response_body["alert"]["heading"]).to eq("The Profile has been saved successfully")
        expect(response_body["alert"]["message"]).to eq("You may access the profile API with API token to get the profile details in future")

        data = response_body['data']

        user = reg.reload.user

        expect(user.dummy).to be_falsy

        expect(data["id"]).to eq(user.id)
        expect(data["name"]).to eq(user.name)
        
        expect(data["gender"]).to eq(user.gender)
        expect(data["date_of_birth"]).to eq(user.date_of_birth.strftime('%d-%m-%Y'))

        expect(data["username"]).to eq(user.username)
        expect(data["email"]).to eq(user.email)
        expect(data["phone"]).to eq(user.phone.to_s)

        expect(data["dummy"]).to be_falsy
        expect(data["country_id"]).to eq(uae.id)
        expect(data["city_id"]).to eq(dubai.id)

        expect(data["profile_picture"]["id"]).to eq(profile_picture.id)
        expect(data["profile_picture"]["profile_id"]).to eq(user.id)
        expect(data["profile_picture"]["created_at"]).to eq(profile_picture.created_at.strftime('%d-%m-%Y %H:%M:%S'))
        expect(data["profile_picture"]["image_large_path"]).not_to be_blank
        expect(data["profile_picture"]["image_small_path"]).not_to be_blank
      end
      it "should update the profile and save a profile picture" do
        user = FactoryBot.create(:approved_user)
        profile_picture = FactoryBot.create(:profile_picture, imageable: user)

        reg = FactoryBot.create(:verified_registration, country: india, city: cochin, user: user)
        dev = FactoryBot.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        profile_data = {
                          name: user.name,
                          gender: user.gender,
                          date_of_birth: user.date_of_birth,
                          email: user.email,
                          country_id: uae.id,
                          city_id: dubai.id,
                          image: fixture_file_upload('spec/dummy/spec/factories/test.jpeg', 'image.jpeg')
                        }

        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        put "/api/v1/update_profile", params: profile_data, headers: headers
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(true)

        expect(response_body["alert"]["heading"]).to eq("The Profile has been saved successfully")
        expect(response_body["alert"]["message"]).to eq("You may access the profile API with API token to get the profile details in future")

        data = response_body['data']

        user = reg.reload.user

        expect(data["id"]).to eq(user.id)
        expect(data["name"]).to eq(user.name)
        
        expect(data["gender"]).to eq(user.gender)
        expect(data["date_of_birth"]).to eq(user.date_of_birth.strftime('%d-%m-%Y'))

        expect(data["username"]).to eq(user.username)
        expect(data["email"]).to eq(user.email)
        expect(data["phone"]).to eq(user.phone.to_s)

        expect(data["dummy"]).to be_falsy
        expect(data["country_id"]).to eq(uae.id)
        expect(data["city_id"]).to eq(dubai.id)

        expect(data["profile_picture"]["id"]).to eq(profile_picture.id)
        expect(data["profile_picture"]["profile_id"]).to eq(user.id)
        expect(data["profile_picture"]["created_at"]).to eq(profile_picture.created_at.strftime('%d-%m-%Y %H:%M:%S'))
        expect(data["profile_picture"]["image_large_path"]).not_to be_blank
        expect(data["profile_picture"]["image_small_path"]).not_to be_blank
      end
      it "should update the profile even if profile picture is invalid" do
        user = FactoryBot.create(:approved_user)
        reg = FactoryBot.create(:verified_registration, country: india, city: cochin, user: user)
        dev = FactoryBot.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        profile_data = {
                          name: user.name,
                          gender: user.gender,
                          date_of_birth: user.date_of_birth,
                          email: user.email,
                          country_id: uae.id,
                          city_id: dubai.id,
                          image: fixture_file_upload('spec/dummy/spec/factories/test.csv', '')
                        }

        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        put "/api/v1/update_profile", params: profile_data, headers: headers
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(true)

        expect(response_body["alert"]["heading"]).to eq("The Profile has been saved successfully")
        expect(response_body["alert"]["message"]).to eq("You may access the profile API with API token to get the profile details in future")

        expect(response_body["errors"]["heading"]).to eq("Saving user/profile image was failed")
        expect(response_body["errors"]["message"]).to eq("Make sure that the arguments are passed according to the API documentation. Please check the API Documentation for more details.")

        data = response_body['data']

        user = reg.reload.user
        expect(user.profile_picture).to be_blank

        expect(data["id"]).to eq(user.id)
        expect(data["name"]).to eq(user.name)
        
        expect(data["gender"]).to eq(user.gender)
        expect(data["date_of_birth"]).to eq(user.date_of_birth.strftime('%d-%m-%Y'))

        expect(data["username"]).to eq(user.username)
        expect(data["email"]).to eq(user.email)
        expect(data["phone"]).to eq(user.phone.to_s)

        expect(data["dummy"]).to be_falsy
        expect(data["country_id"]).to eq(uae.id)
        expect(data["city_id"]).to eq(dubai.id)

        expect(data["profile_picture"]["id"]).to eq("")
        expect(data["profile_picture"]["created_at"]).to eq("")
        expect(data["profile_picture"]["profile_id"]).to eq(user.id)
        expect(data["profile_picture"]["image_large_path"]).to eq("")
        expect(data["profile_picture"]["image_small_path"]).to eq("")
      end
    end
    context 'Negative Cases' do
      it "should set proper errors if api token is not present" do
        user = FactoryBot.create(:user)
        reg = FactoryBot.create(:verified_registration, country: india, city: cochin, user: user)
        dev = FactoryBot.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        profile_data = {
                          name: user.name,
                          gender: user.gender,
                          date_of_birth: user.date_of_birth,
                          email: user.email,
                          country_id: india.id,
                          city_id: cochin.id
                        }

        put "/api/v1/update_profile", params: profile_data
        
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
        
        reg = FactoryBot.create(:verified_registration, country: india, city: cochin, user: nil)
        dev = FactoryBot.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        user = FactoryBot.build(:user)

        profile_data = {
                          name: user.name,
                          gender: user.gender,
                          date_of_birth: user.date_of_birth,
                          email: user.email,
                          country_id: india.id,
                          city_id: cochin.id
                        }

        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        put "/api/v1/update_profile", params: profile_data, headers: headers
        
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
        user = FactoryBot.build(:approved_user)
        reg = FactoryBot.create(:verified_registration, country: india, city: cochin, user: user)
        dev = FactoryBot.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        profile_data = {}

        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        put "/api/v1/update_profile", params: profile_data, headers: headers
        
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

  describe "profile" do
    context "Positive Case" do
      it "should return the profile details along with picture" do
        user = FactoryBot.create(:approved_user, country: india, city: cochin)
        profile_picture = FactoryBot.create(:profile_picture, imageable: user)
        reg = FactoryBot.create(:verified_registration, country: india, city: cochin, user: user)
        dev = FactoryBot.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        get "/api/v1/profile_info", headers: headers
        
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(true)

        data = response_body['data']

        user = reg.reload.user

        expect(data["id"]).to eq(user.id)
        expect(data["name"]).to eq(user.name)
        
        expect(data["gender"]).to eq(user.gender)
        expect(data["date_of_birth"]).to eq(user.date_of_birth.strftime('%d-%m-%Y'))

        expect(data["username"]).to eq(user.username)
        expect(data["email"]).to eq(user.email)
        expect(data["phone"]).to eq(user.phone.to_s)

        expect(data["dummy"]).to be_falsy
        expect(data["country_id"]).to eq(india.id)
        expect(data["city_id"]).to eq(cochin.id)

        expect(data["profile_picture"]["id"]).to eq(profile_picture.id)
        expect(data["profile_picture"]["profile_id"]).to eq(user.id)
        expect(data["profile_picture"]["created_at"]).to eq(profile_picture.created_at.strftime('%d-%m-%Y %H:%M:%S'))
        expect(data["profile_picture"]["image_large_path"]).not_to be_blank
        expect(data["profile_picture"]["image_small_path"]).not_to be_blank
      end
    end
    context 'Negative Cases' do
      it "should set proper errors if api token is not present" do
        user = FactoryBot.create(:user)
        reg = FactoryBot.create(:verified_registration, country: india, city: cochin, user: user)
        dev = FactoryBot.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        profile_data = {
                          name: user.name,
                          gender: user.gender,
                          date_of_birth: user.date_of_birth,
                          email: user.email,
                          country_id: india.id,
                          city_id: cochin.id
                        }

        get "/api/v1/profile_info", params: profile_data
        
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
        
        reg = FactoryBot.create(:verified_registration, country: india, city: cochin, user: nil)
        dev = FactoryBot.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        user = FactoryBot.build(:user)

        profile_data = {
                          name: user.name,
                          gender: user.gender,
                          date_of_birth: user.date_of_birth,
                          email: user.email,
                          country_id: india.id,
                          city_id: cochin.id
                        }

        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        get "/api/v1/profile_info", params: profile_data, headers: headers
        
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