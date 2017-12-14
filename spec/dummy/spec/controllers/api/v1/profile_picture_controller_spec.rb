require "rails_helper"

RSpec.describe Usman::Api::V1::ProfilePictureController, :type => :request do  

  let(:user) { FactoryBot.create(:approved_user) }
  let(:reg) { FactoryBot.create(:verified_registration, user: user) }
  let(:dev) { FactoryBot.create(:verified_device, registration: reg, api_token: SecureRandom.hex) }
  
  describe "profile_picture_base64" do
    context "Positive Case" do
      it "should upload a profile image in base64 format" do

        valid_base64_image = Base64.encode64(File.read('spec/dummy/spec/factories/test.jpeg'))
        image_params =  {
          image: "data:image/png;base64,#{valid_base64_image}"
        }

        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }
        
        post "/api/v1/profile/profile_picture_base64", headers: headers, params: image_params

        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(true)
        expect(response_body["alert"]["heading"]).to eq("User/Profile Image was saved successfully")
        expect(response_body["alert"]["message"]).to eq("You may now use the URL to download the image in future")
        data = response_body['data']

        user.reload
        profile_picture = user.profile_picture

        expect(data["id"]).to eq(profile_picture.id)
        expect(data["profile_id"]).to eq(user.id)
        expect(data["created_at"]).to eq(profile_picture.created_at.strftime('%d-%m-%Y %H:%M:%S'))
        expect(data["image_large_path"]).not_to be_blank
        expect(data["image_small_path"]).not_to be_blank
      end
    end

    context "Negative Case" do
      it "should set proper errors if no api token" do
        valid_base64_image = Base64.encode64(File.read('spec/dummy/spec/factories/test.jpeg'))
        image_params =  {
          image: "data:image/png;base64,#{valid_base64_image}"
        }

        post "/api/v1/profile/profile_picture_base64", params: image_params

        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(false)
        
        expect(response_body["errors"]["heading"]).to eq("Invalid API Token")
        expect(response_body["errors"]["message"]).to eq("Use the API Token you have received after accepting the terms and agreement")
      end

      it "should respond with proper errors for invalid arguments" do
        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }
        
        post "/api/v1/profile/profile_picture_base64", headers: headers

        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(false)
        expect(response_body["errors"]["heading"]).to eq("Saving user/profile image was failed")
        expect(response_body["errors"]["message"]).to eq("Make sure that the arguments are passed according to the API documentation. Please check the API Documentation for more details.")
        expect(response_body["errors"]["details"]).to eq("Image can't be blank")
        data = response_body['data']
      end

      it "should set proper errors if invalid image data is passed" do
        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }
        
        image_params =  { image: "asdasd" }
        
        post "/api/v1/profile/profile_picture_base64", headers: headers, params: image_params

        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(false)
        
        expect(response_body["errors"]["heading"]).to eq("Saving user/profile image was failed")
        expect(response_body["errors"]["message"]).to eq("Make sure that the arguments are passed according to the API documentation. Please check the API Documentation for more details.")
        expect(response_body["errors"]["details"]).to eq("Unable to parse the base64 image data")
      end
    end
  end

  describe "profile_picture" do
    context "Positive Case" do
      it "should upload a profile image for a user who doesn't have one" do
        image_params = { 
          image: fixture_file_upload('spec/dummy/spec/factories/test.jpeg', 'image.jpeg')
        }
        
        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }
        
        post "/api/v1/profile/profile_picture", headers: headers, params: image_params

        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(true)
        expect(response_body["alert"]["heading"]).to eq("User/Profile Image was saved successfully")
        expect(response_body["alert"]["message"]).to eq("You may now use the URL to download the image in future")
        data = response_body['data']

        user.reload
        profile_picture = user.profile_picture

        expect(data["id"]).to eq(profile_picture.id)
        expect(data["profile_id"]).to eq(user.id)
        expect(data["created_at"]).to eq(profile_picture.created_at.strftime('%d-%m-%Y %H:%M:%S'))
        expect(data["image_large_path"]).not_to be_blank
        expect(data["image_small_path"]).not_to be_blank
      end
      it "should upload a profile image for a user who already have one" do
        image_params = { 
          image: fixture_file_upload('spec/dummy/spec/factories/test.jpeg', 'image.jpeg')
        }

        profile_picture = FactoryBot.create(:profile_picture, imageable: user)
        
        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }
        
        post "/api/v1/profile/profile_picture", headers: headers, params: image_params

        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(true)
        expect(response_body["alert"]["heading"]).to eq("User/Profile Image was saved successfully")
        expect(response_body["alert"]["message"]).to eq("You may now use the URL to download the image in future")
        data = response_body['data']

        user.reload
        profile_picture = user.profile_picture

        expect(data["id"]).to eq(profile_picture.id)
        expect(data["profile_id"]).to eq(user.id)
        expect(data["created_at"]).to eq(profile_picture.created_at.strftime('%d-%m-%Y %H:%M:%S'))
        expect(data["image_large_path"]).not_to be_blank
        expect(data["image_small_path"]).not_to be_blank
      end
    end
    context "Negative Case" do
      it "should set proper errors if no api token" do
        image_params = { 
          image: fixture_file_upload('spec/dummy/spec/factories/test.jpeg', 'image.jpeg')
        }
        
        post "/api/v1/profile/profile_picture", params: image_params

        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(false)
        
        expect(response_body["errors"]["heading"]).to eq("Invalid API Token")
        expect(response_body["errors"]["message"]).to eq("Use the API Token you have received after accepting the terms and agreement")
      end

      it "should respond with proper errors for invalid arguments" do
        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }
        
        post "/api/v1/profile/profile_picture", headers: headers

        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(false)
        expect(response_body["errors"]["heading"]).to eq("Saving user/profile image was failed")
        expect(response_body["errors"]["message"]).to eq("Make sure that the arguments are passed according to the API documentation. Please check the API Documentation for more details.")
        expect(response_body["errors"]["details"]).to eq("Image can't be blank")
        data = response_body['data']
      end

      it "should set proper errors if invalid image data is passed" do
        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }
        
        image_params = { 
          image: fixture_file_upload('spec/dummy/spec/factories/test.csv', '')
        }
        
        post "/api/v1/profile/profile_picture", headers: headers, params: image_params

        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(false)
        
        expect(response_body["errors"]["heading"]).to eq("Saving user/profile image was failed")
        expect(response_body["errors"]["message"]).to eq("Make sure that the arguments are passed according to the API documentation. Please check the API Documentation for more details.")
        expect(response_body["errors"]["details"]).not_to be_blank
      end
    end
  end

  describe "destroy_picture_picture" do
    context "Positive Case" do
      it "should delete a profile picture for a user" do
        image_params = { 
          image: fixture_file_upload('spec/dummy/spec/factories/test.jpeg', 'image.jpeg')
        }
        
        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }
        
        profile_picture = FactoryBot.create(:profile_picture, imageable: user)
        delete "/api/v1/profile/profile_picture", headers: headers, params: image_params

        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(true)
        expect(response_body["alert"]["heading"]).to eq("User/Profile Image was deleted successfully")
        expect(response_body["alert"]["message"]).to eq("You may use Profile Picture Upload API to add one again")
        expect(response_body["data"]).to be_blank
        
        user.reload
        expect(user.profile_picture).to be_nil
      end
    end
    context "Negative Case" do
      it "should set proper errors if no api token" do
        image_params = { 
          image: fixture_file_upload('spec/dummy/spec/factories/test.jpeg', 'image.jpeg')
        }
        
        post "/api/v1/profile/profile_picture", params: image_params

        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["success"]).to eq(false)
        
        expect(response_body["errors"]["heading"]).to eq("Invalid API Token")
        expect(response_body["errors"]["message"]).to eq("Use the API Token you have received after accepting the terms and agreement")
      end

      it "should set proper errors if the profile doesn't exist" do
        
        reg = FactoryBot.create(:verified_registration, user: nil)
        dev = FactoryBot.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }

        post "/api/v1/profile/profile_picture", headers: headers
        
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