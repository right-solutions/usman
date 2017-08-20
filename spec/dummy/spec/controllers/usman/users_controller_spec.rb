require 'rails_helper'

describe Usman::Admin::UsersController, :type => :controller do

  let(:user) {FactoryGirl.create(:user)}
  let(:suspended_user) {FactoryGirl.create(:suspended_user)}
  
  let(:site_role) {FactoryGirl.create(:role, name: "Site Admin")}
  
  let(:super_admin_user) {FactoryGirl.create(:super_admin_user)}
  let(:site_admin_user) { 
    site_role
    user = FactoryGirl.create(:approved_user)
    user.add_role("Site Admin")
    user 
  }
  let(:approved_user) {FactoryGirl.create(:approved_user)}
  
  describe "index" do
    3.times { FactoryGirl.create(:approved_user) }
    2.times { FactoryGirl.create(:pending_user) }
    1.times { FactoryGirl.create(:suspended_user) }
    context "Positive Case" do
      it "site admin should be able to view the list of users" do
        session[:id] = site_admin_user.id
        get :index, params: { use_route: 'usman' }
        expect(response.status).to eq(200)
      end

      it "super admin should be able to view the list of users" do
        session[:id] = super_admin_user.id
        get :index, params: { use_route: 'usman' }
        expect(response.status).to eq(200)
      end
    end
    describe "Negative Case" do
      it "other users should not be able to view the list of users" do
        session[:id] = approved_user.id
        get :index, params: { use_route: 'usman' }
        expect(response.status).to eq(302)
        expect(response.redirect_url.starts_with?("http://test.host/sign_in")).to be_truthy
      end

      it "should redirect while accessing the list of users, if the user is not signed in" do
        session[:id] = nil
        get :index, params: { use_route: 'usman' }
        expect(response.status).to eq(302)
        expect(response.redirect_url.starts_with?("http://test.host/sign_in")).to be_truthy
      end
    end
  end

  describe "show" do
    context "Positive Case" do
      it "site admin should be able to view single user details" do
        session[:id] = site_admin_user.id
        get :show, params: { use_route: 'usman', id: user.id }
        expect(response.status).to eq(200)
      end

      it "super admin should be able to view single user details" do
        session[:id] = super_admin_user.id
        get :show, params: { use_route: 'usman', id: user.id }
        expect(response.status).to eq(200)
      end
    end
    describe "Negative Case" do
      it "other users should not be able to view single user details" do
        session[:id] = approved_user.id
        get :show, params: { use_route: 'usman', id: user.id }
        expect(response.status).to eq(302)
        expect(response.redirect_url.starts_with?("http://test.host/sign_in")).to be_truthy
      end

      it "should redirect while accessing single user, if the user is not signed in" do
        session[:id] = nil
        get :show, params: { use_route: 'usman', id: user.id }
        expect(response.status).to eq(302)
        expect(response.redirect_url.starts_with?("http://test.host/sign_in")).to be_truthy
      end
    end
  end

  describe "new" do
    context "Positive Case" do
      it "should display the new form for site admin" do
        session[:id] = site_admin_user.id
        get :new, params: { use_route: 'usman' }, xhr: true
        expect(response.status).to eq(200)
      end
      it "should display the new form for super admin" do
        session[:id] = super_admin_user.id
        get :new, params: { use_route: 'usman' }, xhr: true
        expect(response.status).to eq(200)
      end
    end
    describe "Negative Case" do
      it "should redirect while accessing new form for all other users" do
        session[:id] = approved_user.id
        get :new, params: { use_route: 'usman' }, xhr: true
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end

      it "should redirect while accessing new form if the user is not signed in" do
        session[:id] = nil
        get :new, params: { use_route: 'usman' }, xhr: true
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end
    end
  end

  describe "edit" do
    context "Positive Case" do
      it "should display the edit form for site admin" do
        session[:id] = site_admin_user.id
        get :edit, params: { use_route: 'usman' }, xhr: true
        expect(response.status).to eq(200)
      end
      it "should display the edit form for super admin" do
        session[:id] = super_admin_user.id
        get :edit, params: { use_route: 'usman' }, xhr: true
        expect(response.status).to eq(200)
      end
    end
    describe "Negative Case" do
      it "should redirect while accessing edit form for all other users" do
        session[:id] = approved_user.id
        get :edit, params: { use_route: 'usman' }, xhr: true
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end

      it "should redirect while accessing edit form if the user is not signed in" do
        session[:id] = nil
        get :edit, params: { use_route: 'usman' }, xhr: true
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end
    end
  end

  describe "create" do
    context "Positive Case" do
      it "site admin should be able to create a user" do
        session[:id] = site_admin_user.id
        user_params = FactoryGirl.build(:user).attributes
        user_params[:name] = "Some Name"
        user_params[:password] = "Password@1"
        user_params[:password_confirmation] = "Password@1"
        expect do
          post :create, params: { use_route: 'usman', user: user_params }, xhr: true
        end.to change(User, :count).by(1)
        expect(User.last.name).to match("Some Name")
      end
      it "super admin should be able to create a user" do
        session[:id] = super_admin_user.id
        user_params = FactoryGirl.build(:user).attributes
        user_params[:name] = "Some Name"
        user_params[:password] = "Password@1"
        user_params[:password_confirmation] = "Password@1"
        expect do
          post :create, params: { use_route: 'usman', user: user_params }, xhr: true
        end.to change(User, :count).by(1)
        expect(User.last.name).to match("Some Name")
      end
    end
    describe "Negative Case" do
      it "other users should not be able to create a user" do
        session[:id] = approved_user.id
        user_params = FactoryGirl.build(:user).attributes
        expect do
          post :create, params: { use_route: 'usman', user: user_params }, xhr: true
        end.to change(User, :count).by(0)
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end

      it "should redirect while creating a user, if the user is not signed in" do
        session[:id] = nil
        user_params = FactoryGirl.build(:user).attributes
        expect do
          post :create, params: { use_route: 'usman', user: user_params }, xhr: true
        end.to change(User, :count).by(0)
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end
    end
  end

  describe "update" do
    context "Positive Case" do
      it "site admin should be able to update a user" do
        session[:id] = site_admin_user.id
        user = FactoryGirl.create(:approved_user, name: "Some Name")
        user_params = user.attributes.clone
        user_params["name"] = "Changed Name"
        expect do
          put :update, params: { use_route: 'usman', id: user.id, user: user_params }, xhr: true
        end.to change(Role, :count).by(0)
        expect(user.reload.name).to match("Changed Name")
      end
      it "super admin should be able to update a user" do
        session[:id] = super_admin_user.id
        user = FactoryGirl.create(:approved_user, name: "Some Name")
        user_params = user.attributes.clone
        user_params["name"] = "Changed Name"
        expect do
          put :update, params: { use_route: 'usman', id: user.id, user: user_params }, xhr: true
        end.to change(Role, :count).by(0)
        expect(user.reload.name).to match("Changed Name")
      end
    end
    describe "Negative Case" do
      it "other users should not be able to update a user" do
        session[:id] = approved_user.id
        user = FactoryGirl.create(:approved_user, name: "Some Name")
        user_params = user.attributes.clone
        user_params["name"] = "Changed Name"
        put :update, params: { use_route: 'usman', id: user.id, user: user_params }, xhr: true
        expect(user.reload.name).to match("Some Name")
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end

      it "should redirect while updating a user, if the user is not signed in" do
        session[:id] = nil
        user = FactoryGirl.create(:approved_user, name: "Some Name")
        user_params = user.attributes.clone
        user_params["name"] = "Changed Name"
        put :update, params: { use_route: 'usman', id: user.id, user: user_params }, xhr: true
        expect(user.reload.name).to match("Some Name")
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end
    end
  end

  describe "destroy" do
    context "Positive Case" do
      it "site admin should be able to remove a suspended user" do
        session[:id] = site_admin_user.id
        suspended_user
        expect(suspended_user.can_be_deleted?).to be_truthy
        expect do
          delete :destroy, params: { use_route: 'usman', id: suspended_user.id }, xhr: true
        end.to change(User, :count).by(-1)
      end
      it "super admin should be able to remove a suspended user" do
        session[:id] = super_admin_user.id
        suspended_user
        expect(suspended_user.can_be_deleted?).to be_truthy
        expect do
          delete :destroy, params: { use_route: 'usman', id: suspended_user.id }, xhr: true
        end.to change(User, :count).by(-1)
      end
    end
    describe "Negative Case" do
      it "site admin should not be able to remove an approved user" do
        session[:id] = site_admin_user.id
        user
        user.approve!
        expect(user.can_be_deleted?).to be_falsy
        expect do
          delete :destroy, params: { use_route: 'usman', id: user.id }, xhr: true
        end.to change(User, :count).by(0)
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end
      it "other users should not be able to remove a user" do
        session[:id] = approved_user.id
        user
        expect do
          delete :destroy, params: { use_route: 'usman', id: user.id }, xhr: true
        end.to change(User, :count).by(0)
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end

      it "should redirect while deleting a user, if the user is not signed in" do
        session[:id] = nil
        user
        expect do
          delete :destroy, params: { use_route: 'usman', id: user.id }, xhr: true
        end.to change(User, :count).by(0)
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end
    end
  end

end
