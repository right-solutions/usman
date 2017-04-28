require 'rails_helper'

describe Usman::Admin::UsersController, :type => :controller do

  let(:user) {FactoryGirl.create(:user)}
  let(:approved_user) {FactoryGirl.create(:approved_user)}
  
  describe "index" do
    it "should display all users" do
      3.times { FactoryGirl.create(:approved_user) }
      session[:id] = approved_user.id
      get :index, params: { use_route: 'usman' }
      expect(response.status).to eq(200)
    end

    it "index: should redirect if the user is not signed in" do
      session[:id] = nil
      get :index, params: { use_route: 'usman' }
      expect(response.status).to eq(302)
    end
  end

  describe "show" do
    it "should display all users" do
      session[:id] = approved_user.id
      get :show, params: { use_route: 'usman', id: user.id }
      expect(response.status).to eq(200)
    end

    it "show: should redirect if the user is not signed in" do
      session[:id] = nil
      get :show, params: { use_route: 'usman', id: user.id }
      expect(response.status).to eq(302)
    end
  end

  describe "new" do
    it "should show a new form" do
      session[:id] = approved_user.id
      get :new, params: { use_route: 'usman' }, xhr: true
      expect(response.status).to eq(200)
    end

    it "new: should redirect if the user is not signed in" do
      session[:id] = nil
      get :new, params: { use_route: 'usman' }
      expect(response.status).to eq(302)
    end
  end

  describe "edit" do
    it "should show an edit form" do
      session[:id] = approved_user.id
      get :edit, params: { use_route: 'usman', id: user.id }, xhr: true
      expect(response.status).to eq(200)
    end

    it "edit: should redirect if the user is not signed in" do
      session[:id] = nil
      get :edit, params: { use_route: 'usman', id: user.id }
      expect(response.status).to eq(302)
    end
  end

  describe "create" do
    it "should create a new user" do
      session[:id] = approved_user.id
      user_params = FactoryGirl.build(:user).attributes
      user_params[:password] = "Password@1"
      user_params[:password_confirmation] = "Password@1"
      expect do
        post :create, params: { use_route: 'usman', user: user_params }, xhr: true
      end.to change(User, :count).by(1)
    end

    it "create: should redirect if the user is not signed in" do
      user_params = FactoryGirl.build(:user).attributes
      session[:id] = nil
      post :create, params: { use_route: 'usman', user: user_params }
      expect(response.status).to eq(302)
    end
  end

  describe "update" do
    it "should update an approved user" do
      session[:id] = approved_user.id
      user = FactoryGirl.create(:approved_user)
      user_params = user.attributes.clone
      user_params["name"] = "Changed Name"
      put :update, params: { use_route: 'usman', id: user.id, user: user_params }
      expect(user.reload.name).to match("Changed Name")
    end

    it "should not update a suspended user" do
      session[:id] = approved_user.id
      user = FactoryGirl.create(:suspended_user)
      user_params = user.attributes
      user_params["name"] = "Changed Name"
      put :update, params: { use_route: 'usman', id: user.id, user: user_params }
      expect(user.reload.name).not_to match("Changed Name")
    end

    it "update: should redirect if the user is not signed in" do
      user_params = FactoryGirl.create(:user).attributes
      session[:id] = nil
      put :update, params: { use_route: 'usman', id: user.id, user: user_params }
      expect(response.status).to eq(302)
    end
  end

  describe "destroy" do
    it "should destroy a suspended user" do
      session[:id] = approved_user.id
      f = FactoryGirl.create(:suspended_user)
      expect do
        delete :destroy, params: { use_route: 'usman', id: f.id }  
      end.to change(User, :count).by(-1)
      expect(User.exists?(f.id)).to eq(false)
    end

    it "should not destroy an approved user" do
      session[:id] = approved_user.id
      f = FactoryGirl.create(:approved_user)
      expect do
        delete :destroy, params: { use_route: 'usman', id: f.id }  
      end.to change(User, :count).by(0)
      expect(User.exists?(f.id)).to eq(true)
    end

    it "destroy: should redirect if the user is not signed in" do
      FactoryGirl.create(:user)
      session[:id] = nil
      delete :destroy, params: { use_route: 'usman', id: user.id }
      expect(response.status).to eq(302)
    end
  end

end
