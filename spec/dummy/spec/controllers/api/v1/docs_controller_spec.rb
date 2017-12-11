require 'spec_helper'

describe Usman::Api::V1::DocsController, :type => :controller do

  describe "should load all doc pages" do

    let(:site_role) {FactoryGirl.create(:role, name: "Site Admin")}
  
    let(:super_admin_user) {FactoryGirl.create(:super_admin_user)}
    let(:site_admin_user) { 
      site_role
      user = FactoryGirl.create(:approved_user)
      user.add_role("Site Admin")
      user 
    }
    let(:approved_user) {FactoryGirl.create(:approved_user)}
    
    it "register" do
      session[:id] = site_admin_user.id
      get :register, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "resend_otp" do
      session[:id] = site_admin_user.id
      get :resend_otp, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "verify_otp" do
      session[:id] = site_admin_user.id
      get :verify_otp, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "accept_tac" do
      session[:id] = site_admin_user.id
      get :accept_tac, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "create_profile" do
      session[:id] = site_admin_user.id
      get :create_profile, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "update_profile" do
      session[:id] = site_admin_user.id
      get :update_profile, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "get_profile_info" do
      session[:id] = site_admin_user.id
      get :get_profile_info, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "upload_profile_picture_base64" do
      session[:id] = site_admin_user.id
      get :upload_profile_picture_base64, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "upload_profile_picture" do
      session[:id] = site_admin_user.id
      get :upload_profile_picture, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "delete_profile_picture" do
      session[:id] = site_admin_user.id
      get :delete_profile_picture, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    # Contacts API Docs
    it "contacts_sync" do
      session[:id] = site_admin_user.id
      get :contacts_sync, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "all_contacts" do
      session[:id] = site_admin_user.id
      get :all_contacts, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "single_contact" do
      session[:id] = site_admin_user.id
      get :single_contact, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    # Change Number & Delete Account API Docs
    it "send_otp_to_change_number" do
      session[:id] = site_admin_user.id
      get :send_otp_to_change_number, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "change_number" do
      session[:id] = site_admin_user.id
      get :change_number, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "delete_account" do
      session[:id] = site_admin_user.id
      get :delete_account, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end
    
  end

end
