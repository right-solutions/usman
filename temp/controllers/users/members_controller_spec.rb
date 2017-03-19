require 'rails_helper'

describe Users::MembersController, :type => :controller do
  let(:admin_user) {FactoryGirl.create(:admin_user)}
  let(:user_1) {FactoryGirl.create(:active_user)}
  let(:user_2) {FactoryGirl.create(:active_user)}

  describe "GET show" do
    it "assigns the requested user as @user" do
      get :show, {:id => user_1.to_param}, {id: admin_user.id}
      expect(assigns(:user)).to eq (user_1)
    end
  end

  describe "GET index" do
    it "assigns all practice as @practise" do
      [user_1, user_2]
      get :index, nil, {id: admin_user.id}
      expect(assigns[:users]).to match_array([admin_user,user_1, user_2])
    end
  end
end
