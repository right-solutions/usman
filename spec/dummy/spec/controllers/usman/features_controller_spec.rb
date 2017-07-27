require 'rails_helper'

describe Usman::Admin::FeaturesController, :type => :controller do

  let(:feature) {FactoryGirl.create(:feature)}
  let(:super_admin_user) {FactoryGirl.create(:super_admin_user)}
  
  describe "index" do
    it "should display all features" do
      3.times { FactoryGirl.create(:published_feature) }
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
    it "should display all features" do
      session[:id] = super_admin_user.id
      get :show, params: { use_route: 'usman', id: feature.id }
      expect(response.status).to eq(200)
    end

    it "show: should redirect if the user is not signed in" do
      session[:id] = nil
      get :show, params: { use_route: 'usman', id: feature.id }
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
      get :edit, params: { use_route: 'usman', id: feature.id }, xhr: true
      expect(response.status).to eq(200)
    end
    
    it "edit: should redirect if the user is not signed in" do
      session[:id] = nil
      get :edit, params: { use_route: 'usman', id: feature.id }
      expect(response.status).to eq(302)
    end
  end

  describe "create" do
    it "should create a new feature" do
      session[:id] = super_admin_user.id
      feature_params = FactoryGirl.build(:feature).attributes
      expect do
        post :create, params: { use_route: 'usman', feature: feature_params }
      end.to change(Feature, :count).by(1)
    end
    
    it "create: should redirect if the user is not signed in" do
      feature_params = FactoryGirl.build(:feature).attributes
      session[:id] = nil
      post :create, params: { use_route: 'usman', feature: feature_params }
      expect(response.status).to eq(302)
    end
  end

  describe "update" do
    it "should update a feature" do
      session[:id] = super_admin_user.id
      feature_params = FactoryGirl.create(:feature).attributes
      feature_params["name"] = "Changed Name"
      put :update, params: { use_route: 'usman', id: feature.id, feature: feature_params }
    end
    
    it "update: should redirect if the user is not signed in" do
      feature_params = FactoryGirl.create(:feature).attributes
      session[:id] = nil
      put :update, params: { use_route: 'usman', id: feature.id, feature: feature_params }
      expect(response.status).to eq(302)
    end
  end

  describe "destroy" do
    it "should not destroy a feature" do
      session[:id] = super_admin_user.id
      f = FactoryGirl.create(:feature)
      expect do
        delete :destroy, params: { use_route: 'usman', id: f.id }  
      end.to change(Feature, :count).by(0)
      expect(Feature.exists?(f.id)).to eq(true)
    end
    
    it "destroy: should redirect if the user is not signed in" do
      FactoryGirl.create(:feature)
      session[:id] = nil
      delete :destroy, params: { use_route: 'usman', id: feature.id }
      expect(response.status).to eq(302)
    end
  end

end
