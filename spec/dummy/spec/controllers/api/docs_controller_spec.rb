require 'spec_helper'

describe Usman::Api::V1::DocsController, :type => :controller do

  describe "should load all doc pages" do
    
    it "register" do
      get :register, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "resend_otp" do
      get :resend_otp, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "verify_otp" do
      get :verify_otp, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "accept_tac" do
      get :accept_tac, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "create_profile" do
      get :create_profile, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "update_profile" do
      get :update_profile, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "get_profile_info" do
      get :get_profile_info, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "upload_profile_picture_base64" do
      get :upload_profile_picture_base64, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "upload_profile_picture" do
      get :upload_profile_picture, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "delete_profile_picture" do
      get :delete_profile_picture, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end
    
  end

end
