require 'rails_helper'

describe Usman::SessionsController, :type => :controller do

  let(:approved_user) {FactoryGirl.create(:approved_user)}
  let(:pending_user) {FactoryGirl.create(:pending_user)}
  let(:suspended_user) {FactoryGirl.create(:suspended_user)}

  describe "sign_in" do
    it "should display the sign in form" do
      get :sign_in, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end
  end

  describe "create_session" do

    context "positive case" do
      it "should create session with email" do
        sign_in_params = { login_handle: approved_user.email, password: approved_user.password, use_route: 'usman' }
        post :create_session, params: sign_in_params
        expect(session[:id].to_s).to  eq(approved_user.id.to_s)
      end

      it "should create session with username" do
        sign_in_params = { login_handle: approved_user.username, password: approved_user.password, use_route: 'usman' }
        post :create_session, params: sign_in_params
        expect(session[:id].to_s).to  eq(approved_user.id.to_s)
      end
    end

    context "negative case" do
      it "invalid email" do
        sign_in_params = { login_handle: "invalid@email.com", use_route: 'usman' }
        session[:id] = nil
        post :create_session, params: sign_in_params
        expect(session[:id]).to be_nil
      end

      it "invalid password" do
        sign_in_params = { login_handle: approved_user.email, password: "Invalid", use_route: 'usman' }
        session[:id] = nil
        post :create_session, params: sign_in_params
        expect(session[:id]).to be_nil
      end

      it "inactive user" do
        sign_in_params = { login_handle: pending_user.email, password: pending_user.password, use_route: 'usman' }
        session[:id] = nil
        post :create_session, params: sign_in_params
        expect(session[:id]).to be_nil
      end

      it "suspended user" do
        sign_in_params = { login_handle: suspended_user.email, password: suspended_user.password, use_route: 'usman' }
        session[:id] = nil
        post :create_session, params: sign_in_params
        expect(session[:id]).to be_nil
      end
    end
  end

  describe "destroy a session" do
    it "should delete session of user" do
      delete :sign_out, params: {:id => approved_user.id, use_route: 'usman'}, cookies: {id: approved_user.id}
      expect(response).to redirect_to("/sign_in?locale=en")
    end
  end
end
