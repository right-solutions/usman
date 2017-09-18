require 'rails_helper'

describe Usman::RolesController, :type => :controller do

  let(:role) {FactoryGirl.create(:role, name: "Some Name")}
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
    3.times { FactoryGirl.create(:role) }
    context "Positive Case" do
      it "site admin should be able to view the list of roles" do
        session[:id] = site_admin_user.id
        get :index, params: { use_route: 'usman' }
        expect(response.status).to eq(200)
      end

      it "super admin should be able to view the list of roles" do
        session[:id] = super_admin_user.id
        get :index, params: { use_route: 'usman' }
        expect(response.status).to eq(200)
      end
    end
    describe "Negative Case" do
      it "other users should not be able to view the list of roles" do
        session[:id] = approved_user.id
        get :index, params: { use_route: 'usman' }
        expect(response.status).to eq(401)
      end

      it "should redirect while viewing the roles list, if the user is not signed in" do
        session[:id] = nil
        get :index, params: { use_route: 'usman' }
        expect(response.status).to eq(302)
        expect(response.redirect_url.starts_with?("http://test.host/sign_in")).to be_truthy
      end
    end
  end

  describe "show" do
    context "Positive Case" do
      it "site admin should be able to view single role details" do
        session[:id] = site_admin_user.id
        get :show, params: { use_route: 'usman', id: role.id }
        expect(response.status).to eq(200)
      end
      it "super admin should be able to view single role details" do
        session[:id] = super_admin_user.id
        get :show, params: { use_route: 'usman', id: role.id }
        expect(response.status).to eq(200)
      end
    end
    describe "Negative Case" do
      it "other users should not be able to view single role details" do
        session[:id] = approved_user.id
        get :show, params: { use_route: 'usman', id: role.id }
        expect(response.status).to eq(401)
      end

      it "should redirect while accessing single role, if the user is not signed in" do
        session[:id] = nil
        get :show, params: { use_route: 'usman', id: role.id }
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
      it "site admin should be able to create a role" do
        session[:id] = site_admin_user.id
        role_params = FactoryGirl.build(:role, name: "Some Name").attributes
        expect do
          post :create, params: { use_route: 'usman', role: role_params }, xhr: true
        end.to change(Role, :count).by(1)
        expect(Role.last.name).to match("Some Name")
      end
      it "super admin should be able to create a role" do
        session[:id] = super_admin_user.id
        role_params = FactoryGirl.build(:role).attributes
        role_params[:name] = "Some Name"
        expect do
          post :create, params: { use_route: 'usman', role: role_params }, xhr: true
        end.to change(Role, :count).by(1)
        expect(Role.last.name).to match("Some Name")
      end
    end
    describe "Negative Case" do
      it "other users should not be able to create a role" do
        session[:id] = approved_user.id
        role_params = FactoryGirl.build(:role, name: "Some Name").attributes
        expect do
          post :create, params: { use_route: 'usman', role: role_params }, xhr: true
        end.to change(Role, :count).by(0)
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end

      it "should redirect while creating a role, if the user is not signed in" do
        session[:id] = nil
        role_params = FactoryGirl.build(:role, name: "Some Name").attributes
        expect do
          post :create, params: { use_route: 'usman', role: role_params }, xhr: true
        end.to change(Role, :count).by(0)
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end
    end
  end

  describe "update" do
    context "Positive Case" do
      it "site admin should be able to update a role" do
        session[:id] = site_admin_user.id
        role = FactoryGirl.create(:role, name: "Some Name")
        role_params = role.attributes.clone
        role_params["name"] = "Changed Name"
        expect do
          put :update, params: { use_route: 'usman', id: role.id, role: role_params }, xhr: true
        end.to change(Role, :count).by(0)
        expect(role.reload.name).to match("Changed Name")
      end
      it "super admin should be able to update a role" do
        session[:id] = super_admin_user.id
        role = FactoryGirl.create(:role, name: "Some Name")
        role_params = role.attributes.clone
        role_params["name"] = "Changed Name"
        expect do
          put :update, params: { use_route: 'usman', id: role.id, role: role_params }, xhr: true
        end.to change(Role, :count).by(0)
        expect(role.reload.name).to match("Changed Name")
      end
    end
    describe "Negative Case" do
      it "other users should not be able to update a role" do
        session[:id] = approved_user.id
        role = FactoryGirl.create(:role, name: "Some Name")
        role_params = role.attributes.clone
        role_params["name"] = "Changed Name"
        put :update, params: { use_route: 'usman', id: role.id, role: role_params }, xhr: true
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
        expect(role.reload.name).to match("Some Name")
      end

      it "should redirect while updating a role, if the user is not signed in" do
        session[:id] = nil
        role = FactoryGirl.create(:role, name: "Some Name")
        role_params = role.attributes.clone
        role_params["name"] = "Changed Name"
        put :update, params: { use_route: 'usman', id: role.id, role: role_params }, xhr: true
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
        expect(role.reload.name).to match("Some Name")
      end
    end
  end

  describe "destroy" do
    context "Positive Case" do
      it "site admin should be able to remove a role" do
        session[:id] = site_admin_user.id
        role
        expect do
          delete :destroy, params: { use_route: 'usman', id: role.id }, xhr: true
        end.to change(Role, :count).by(-1)
      end
      it "super admin should be able to remove a role" do
        session[:id] = super_admin_user.id
        role
        expect do
          delete :destroy, params: { use_route: 'usman', id: role.id }, xhr: true
        end.to change(Role, :count).by(-1)
      end
    end
    describe "Negative Case" do
      it "other users should not be able to remove a role" do
        session[:id] = approved_user.id
        role
        expect do
          delete :destroy, params: { use_route: 'usman', id: role.id }, xhr: true
        end.to change(Role, :count).by(0)
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end

      it "should redirect while deleting a role, if the user is not signed in" do
        session[:id] = nil
        role
        expect do
          delete :destroy, params: { use_route: 'usman', id: role.id }, xhr: true
        end.to change(Role, :count).by(0)
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end
    end
  end

end
