require 'rails_helper'

describe Usman::AuthenticationService do
  let(:approved_user) {FactoryGirl.create(:approved_user)}
  let(:pending_user) {FactoryGirl.create(:pending_user)}
  let(:suspended_user) {FactoryGirl.create(:suspended_user)}

  describe 'initialize' do

    context 'active user registration' do
      it "should authenticate the user with username" do
        params = {login_handle: approved_user.username, password: ConfigCenter::Defaults::PASSWORD}
        auth_service = Usman::AuthenticationService.new(params)
        expect(auth_service.login_handle).to eq(approved_user.username)
        expect(auth_service.password).to eq(ConfigCenter::Defaults::PASSWORD)
        expect(auth_service.user).to eq(approved_user)
        expect(auth_service.error).to eq(nil)
      end

      it "should authenticate the user with email" do
        params = {login_handle: approved_user.email, password: ConfigCenter::Defaults::PASSWORD}
        auth_service = Usman::AuthenticationService.new(params)
        expect(auth_service.login_handle).to eq(approved_user.email)
        expect(auth_service.password).to eq(ConfigCenter::Defaults::PASSWORD)
        expect(auth_service.user).to eq(approved_user)
        expect(auth_service.error).to eq(nil)
      end
    end

    context 'invalid email registration' do
      it "should not authenticate with invalid email" do
        params = {login_handle: "invalid@email.com"}
        auth_service = Usman::AuthenticationService.new(params)
        expect(auth_service.login_handle).to eq("invalid@email.com")
        expect(auth_service.password).to eq(nil)
        expect(auth_service.user).to eq(nil)
        expect(auth_service.error).to eq("authentication.invalid_login")
      end
    end

    context 'invalid password registration' do
      it "should not authenticate with invalid password" do
        params = {login_handle: approved_user.email, password: "Invalid Password"}
        auth_service = Usman::AuthenticationService.new(params)
        expect(auth_service.login_handle).to eq(approved_user.email)
        expect(auth_service.password).to eq("Invalid Password")
        expect(auth_service.user).to eq(approved_user)
        expect(auth_service.error).to eq("authentication.invalid_login")
      end
    end

    context 'user account is not activated' do
      it "should not authenticate when status is inactive" do
        params = {login_handle: pending_user.email, password: ConfigCenter::Defaults::PASSWORD}
        auth_service = Usman::AuthenticationService.new(params)
        expect(auth_service.login_handle).to eq(pending_user.email)
        expect(auth_service.password).to eq(ConfigCenter::Defaults::PASSWORD)
        expect(auth_service.user).to eq(pending_user)
        expect(auth_service.error).to eq("authentication.user_is_pending")
      end

      it "should not authenticate when status is suspended" do
        params = {login_handle: suspended_user.email, password: ConfigCenter::Defaults::PASSWORD}
        auth_service = Usman::AuthenticationService.new(params)
        expect(auth_service.login_handle).to eq(suspended_user.email)
        expect(auth_service.password).to eq(ConfigCenter::Defaults::PASSWORD)
        expect(auth_service.user).to eq(suspended_user)
        expect(auth_service.error).to eq("authentication.user_is_suspended")
      end
    end

  end
end