require 'rails_helper'

describe Usman::Admin::RolesController, :type => :controller do

  let(:role) {FactoryGirl.create(:role)}
  let(:super_admin_user) { user = FactoryGirl.create(:super_admin_user) }
  
  describe "index" do
    it "should display all roles" do
      3.times { FactoryGirl.create(:role) }
      session[:id] = super_admin_user.id
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
    it "should display all roles" do
      session[:id] = super_admin_user.id
      get :show, params: { use_route: 'usman', id: role.id }
      expect(response.status).to eq(200)
    end

    it "show: should redirect if the user is not signed in" do
      session[:id] = nil
      get :show, params: { use_route: 'usman', id: role.id }
      expect(response.status).to eq(302)
    end
  end

  describe "new" do
    it "should show a new form" do
      session[:id] = super_admin_user.id
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
      session[:id] = super_admin_user.id
      get :edit, params: { use_route: 'usman', id: role.id }, xhr: true
      expect(response.status).to eq(200)
    end
    
    it "edit: should redirect if the user is not signed in" do
      session[:id] = nil
      get :edit, params: { use_route: 'usman', id: role.id }
      expect(response.status).to eq(302)
    end
  end

  describe "create" do
    it "should create a new role" do
      session[:id] = super_admin_user.id
      role_params = FactoryGirl.build(:role).attributes
      expect do
        post :create, params: { use_route: 'usman', role: role_params }
      end.to change(Role, :count).by(1)
    end
    
    it "create: should redirect if the user is not signed in" do
      role_params = FactoryGirl.build(:role).attributes
      session[:id] = nil
      post :create, params: { use_route: 'usman', role: role_params }
      expect(response.status).to eq(302)
    end
  end

  describe "update" do
    it "should update the role" do
      session[:id] = super_admin_user.id
      role_params = FactoryGirl.create(:role).attributes
      role_params["name"] = "Changed Name"
      put :update, params: { use_route: 'usman', id: role.id, role: role_params }
    end
    
    it "update: should redirect if the user is not signed in" do
      role_params = FactoryGirl.create(:role).attributes
      session[:id] = nil
      put :update, params: { use_route: 'usman', id: role.id, role: role_params }
      expect(response.status).to eq(302)
    end
  end

  describe "destroy" do
    it "should destroy the role" do
      session[:id] = super_admin_user.id
      f = FactoryGirl.create(:role)
      expect do
        delete :destroy, params: { use_route: 'usman', id: f.id }  
      end.to change(Role, :count).by(-1)
      expect(Role.exists?(f.id)).to eq(false)
    end
    
    it "destroy: should redirect if the user is not signed in" do
      FactoryGirl.create(:role)
      session[:id] = nil
      delete :destroy, params: { use_route: 'usman', id: role.id }
      expect(response.status).to eq(302)
    end
  end

end
