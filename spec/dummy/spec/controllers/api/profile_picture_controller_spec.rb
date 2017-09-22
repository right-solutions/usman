require "rails_helper"

RSpec.describe Usman::Api::V1::ProfilePictureController, :type => :request do  

  let(:user) { FactoryGirl.create(:approved_user) }
  let(:reg) { FactoryGirl.create(:verified_registration, user: user) }
  let(:dev) { FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex) }
  
  describe "base64_profile_picture" do
    context "Positive Case" do
      it "should upload a profile image in base64 format" do

        valid_base64_image = Base64.encode64(File.read('spec/dummy/spec/factories/test.jpeg'))
        image_params =  {
          image: "data:image/png;base64,#{valid_base64_image}"
        }

        headers = {
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Token.encode_credentials(dev.api_token)
        }
        
        post "/api/v1/profile/base64_profile_picture", headers: headers, params: image_params

        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(true)
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

        post "/api/v1/profile/base64_profile_picture", params: image_params

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
        
        post "/api/v1/profile/base64_profile_picture", headers: headers

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
        
        post "/api/v1/profile/base64_profile_picture", headers: headers, params: image_params

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
      it "should upload a profile image" do
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

end