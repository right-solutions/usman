require 'rails_helper'

describe Usman::FeaturesController, :type => :controller do

  let(:feature) {FactoryGirl.create(:feature)}
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
    3.times { FactoryGirl.create(:published_feature) }
    context "Positive Case" do
      it "super admin should be able to view the list of features" do
        session[:id] = super_admin_user.id
        get :index, params: { use_route: 'usman' }
        expect(response.status).to eq(200)
      end
    end
    describe "Negative Case" do
      it "site admin should not be able to view the list of features" do
        session[:id] = site_admin_user.id
        get :index, params: { use_route: 'usman' }
        expect(response.status).to eq(401)
      end

      it "other users should not be able to view the list of features" do
        session[:id] = approved_user.id
        get :index, params: { use_route: 'usman' }
        expect(response.status).to eq(401)
      end

      it "should redirect while viewing the features list, if the user is not signed in" do
        session[:id] = nil
        get :index, params: { use_route: 'usman' }
        expect(response.status).to eq(302)
        expect(response.redirect_url.starts_with?("http://test.host/sign_in")).to be_truthy
      end
    end
  end

  describe "show" do
    context "Positive Case" do
      it "super admin should be able to view single feature details" do
        session[:id] = super_admin_user.id
        get :show, params: { use_route: 'usman', id: feature.id }
        expect(response.status).to eq(200)
      end
    end
    describe "Negative Case" do
      it "site admin should not be able to view single feature details" do
        session[:id] = site_admin_user.id
        get :show, params: { use_route: 'usman', id: feature.id }
        expect(response.status).to eq(401)
      end

      it "other users should not be able to view single feature details" do
        session[:id] = approved_user.id
        get :show, params: { use_route: 'usman', id: feature.id }
        expect(response.status).to eq(401)
      end

      it "should redirect while accessing single feature, if the user is not signed in" do
        session[:id] = nil
        get :show, params: { use_route: 'usman', id: feature.id }
        expect(response.status).to eq(302)
        expect(response.redirect_url.starts_with?("http://test.host/sign_in")).to be_truthy
      end
    end
  end

  describe "new" do
    context "Positive Case" do
      it "should display the new form for super admin" do
        session[:id] = super_admin_user.id
        get :new, params: { use_route: 'usman' }, xhr: true
        expect(response.status).to eq(200)
      end
    end
    describe "Negative Case" do
      it "should not display the new form for site admin" do
        session[:id] = site_admin_user.id
        get :new, params: { use_route: 'usman' }, xhr: true
        expect(response.status).to eq(200)
      end

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
      it "should display the edit form for super admin" do
        session[:id] = super_admin_user.id
        get :edit, params: { use_route: 'usman' }, xhr: true
        expect(response.status).to eq(200)
      end
    end
    describe "Negative Case" do
      it "should not display the edit form for site admin" do
        session[:id] = site_admin_user.id
        get :edit, params: { use_route: 'usman' }, xhr: true
        expect(response.status).to eq(200)
      end
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
      it "super admin should be able to create a feature" do
        session[:id] = super_admin_user.id
        feature_params = FactoryGirl.build(:feature, name: "Some Name").attributes
        expect do
          post :create, params: { use_route: 'usman', feature: feature_params }, xhr: true
        end.to change(Feature, :count).by(1)
        expect(Feature.last.name).to match("Some Name")
      end
    end
    describe "Negative Case" do
      it "site admin should not be able to create a feature" do
        session[:id] = site_admin_user.id
        feature_params = FactoryGirl.build(:feature, name: "Some Name").attributes
        expect do
          post :create, params: { use_route: 'usman', feature: feature_params }, xhr: true
        end.to change(Feature, :count).by(0)
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end

      it "other users should not be able to create a feature" do
        session[:id] = approved_user.id
        feature_params = FactoryGirl.build(:feature, name: "Some Name").attributes
        expect do
          post :create, params: { use_route: 'usman', feature: feature_params }, xhr: true
        end.to change(Feature, :count).by(0)
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end

      it "should redirect while creating a feature, if the user is not signed in" do
        session[:id] = nil
        feature_params = FactoryGirl.build(:feature, name: "Some Name").attributes
        expect do
          post :create, params: { use_route: 'usman', feature: feature_params }, xhr: true
        end.to change(Feature, :count).by(0)
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end
    end
  end

  describe "update" do
    context "Positive Case" do
      it "super admin should be able to update a feature" do
        session[:id] = super_admin_user.id
        feature = FactoryGirl.create(:feature, name: "Some Name")
        feature_params = feature.attributes.clone
        feature_params["name"] = "Changed Name"
        expect do
          put :update, params: { use_route: 'usman', id: feature.id, feature: feature_params }, xhr: true
        end.to change(Feature, :count).by(0)
        expect(feature.reload.name).to match("Changed Name")
      end
    end
    describe "Negative Case" do

      it "site admin should not be able to update a feature" do
        session[:id] = site_admin_user.id
        feature = FactoryGirl.create(:feature, name: "Some Name")
        feature_params = feature.attributes.clone
        feature_params["name"] = "Changed Name"
        expect do
          put :update, params: { use_route: 'usman', id: feature.id, feature: feature_params }, xhr: true
        end.to change(Feature, :count).by(0)
        expect(feature.reload.name).to match("Some Name")
      end

      it "other users should not be able to update a feature" do
        session[:id] = approved_user.id
        feature = FactoryGirl.create(:feature, name: "Some Name")
        feature_params = feature.attributes.clone
        feature_params["name"] = "Changed Name"
        put :update, params: { use_route: 'usman', id: feature.id, feature: feature_params }, xhr: true
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
        expect(feature.reload.name).to match("Some Name")
      end

      it "should redirect while updating a feature, if the user is not signed in" do
        session[:id] = nil
        feature = FactoryGirl.create(:feature, name: "Some Name")
        feature_params = feature.attributes.clone
        feature_params["name"] = "Changed Name"
        put :update, params: { use_route: 'usman', id: feature.id, feature: feature_params }, xhr: true
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
        expect(feature.reload.name).to match("Some Name")
      end
    end
  end

  describe "destroy" do
    context "Positive Case" do
      it "super admin should be able to remove a feature" do
        session[:id] = super_admin_user.id
        feature
        expect do
          delete :destroy, params: { use_route: 'usman', id: feature.id }, xhr: true
        end.to change(Feature, :count).by(-1)
      end
    end
    describe "Negative Case" do
      it "site admin should not be able to remove a feature" do
        session[:id] = site_admin_user.id
        feature
        expect do
          delete :destroy, params: { use_route: 'usman', id: feature.id }, xhr: true
        end.to change(Feature, :count).by(0)
      end
      it "other users should not be able to remove a feature" do
        session[:id] = approved_user.id
        feature
        expect do
          delete :destroy, params: { use_route: 'usman', id: feature.id }, xhr: true
        end.to change(Feature, :count).by(0)
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end

      it "should redirect while deleting a feature, if the user is not signed in" do
        session[:id] = nil
        feature
        expect do
          delete :destroy, params: { use_route: 'usman', id: feature.id }, xhr: true
        end.to change(Feature, :count).by(0)
        expect(response.status).to eq(200)
        expect(response.body).to eq("")
      end
    end
  end

end
