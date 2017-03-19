require 'spec_helper'

RSpec.describe User, type: :model do

  let(:user) {FactoryGirl.build(:user)}
  let(:ram) {FactoryGirl.create(:user, name: "Ram", email: "ram@domain.com", username: "ram1234", designation: "Prince")}
  let(:lakshman) {FactoryGirl.create(:user, name: "Lakshman", email: "lakshmanword@domain.com", username: "lakshman1234", designation: "Prince")}
  let(:sita) {FactoryGirl.create(:user, name: "Sita", email: "sita@domain.com", username: "sita1234word", designation: "Princess")}

  context "Factory" do
    it "should validate all the factories" do
      expect(FactoryGirl.build(:user).valid?).to be true
      expect(FactoryGirl.build(:pending_user).valid?).to be true
      expect(FactoryGirl.build(:approved_user).valid?).to be true
      expect(FactoryGirl.build(:suspended_user).valid?).to be true
      expect(FactoryGirl.build(:super_admin_user).valid?).to be true
    end
    it "should set right status for all factories" do
      expect(FactoryGirl.build(:user).status).to match "pending"
      expect(FactoryGirl.build(:pending_user).status).to match "pending"
      expect(FactoryGirl.build(:approved_user).status).to match "approved"
      expect(FactoryGirl.build(:suspended_user).status).to match "suspended"
      expect(FactoryGirl.build(:super_admin_user).status).to match "approved"
    end
  end

  context "Validations" do
    it { should validate_presence_of :name }
    it { should allow_value('Krishnaprasad Varma').for(:name )}
    it { should_not allow_value('KP').for(:name )}
    it { should_not allow_value("x"*257).for(:name )}

    it { should validate_presence_of :username }
    it { should allow_value('kpvarma').for(:username )}
    it { should allow_value('kpvarma1234').for(:username )}
    it { should_not allow_value('kp varma').for(:username )}
    it { should_not allow_value('kp-varma').for(:username )}
    it { should_not allow_value('kp*varma').for(:username )}
    it { should_not allow_value('xx').for(:username )}
    it { should_not allow_value("x"*129).for(:username )}

    it { should validate_presence_of :email }
    it { should allow_value('something@domain.com').for(:email )}
    it { should_not allow_value('something domain.com').for(:email )}
    it { should_not allow_value('something.domain.com').for(:email )}
    it { should_not allow_value('ED').for(:email )}
    it { should_not allow_value("x"*257).for(:email )}

    it { should validate_presence_of :password }
    it { should allow_value('Password@1').for(:password )}
    it { should_not allow_value('password').for(:password )}
    it { should_not allow_value('password1').for(:password )}
    it { should_not allow_value('password@1').for(:password )}
    it { should_not allow_value('ED').for(:password )}
    it { should_not allow_value("a"*257).for(:password )}

    it { should validate_inclusion_of(:status).in_array(User::STATUS_LIST)  }
  end

  context "Associations" do
    it { should have_one(:profile_picture) }
    it { should have_many(:permissions) }
    it { should have_many(:features) }
  end

  context "Class Methods" do
    it "search" do
      arr = [ram, lakshman, sita]
      expect(User.search("Ram")).to match_array([ram])
      expect(User.search("Lakshman")).to match_array([lakshman])
      expect(User.search("Sita")).to match_array([sita])
      expect(User.search("Prince")).to match_array([ram, lakshman, sita])
      expect(User.search("Princess")).to match_array([sita])
    end

    it "find_by_email_or_username" do
      arr = [ram, lakshman, sita]
      expect(User.find_by_email_or_username("ram@domain.com")).to eq(ram)
      expect(User.find_by_email_or_username("ram1234")).to eq(ram)
    end

    it "scope pending" do
      expect(User.pending.all).to match_array [ram, lakshman, sita]
    end

    it "scope approved" do
      approved_user = FactoryGirl.create(:approved_user)
      expect(User.approved.all).to match_array [approved_user]
    end

    it "scope suspended" do
      suspended_user = FactoryGirl.create(:suspended_user)
      expect(User.suspended.all).to match_array [suspended_user]
    end
    
  end

  context "Instance Methods" do

    it "token_expired?" do
      token_created_at = Time.now - 30.minute
      u = FactoryGirl.build(:user, token_created_at: token_created_at)
      expect(u.token_expired?).to be_truthy

      token_created_at = Time.now - 29.minute
      u = FactoryGirl.build(:user, token_created_at: token_created_at)
      expect(u.token_expired?).to be_falsy
    end

    it "is_super_admin?" do
      u = FactoryGirl.build(:user)
      expect(u.is_super_admin?).to be_falsy

      u = FactoryGirl.build(:super_admin_user)
      expect(u.is_super_admin?).to be_truthy
    end

    it "approved" do
      pending_user = FactoryGirl.create(:pending_user)
      expect(pending_user.status).to match "pending"
      pending_user.approve!
      expect(pending_user.status).to match "approved"
    end

    it "pending" do
      approved_user = FactoryGirl.create(:approved_user)
      expect(approved_user.status).to match "approved"
      approved_user.pending!
      expect(approved_user.status).to match "pending"
    end

    it "suspended" do
      approved_user = FactoryGirl.create(:approved_user)
      expect(approved_user.status).to match "approved"
      approved_user.suspend!
      expect(approved_user.status).to match "suspended"
    end

    it "display_name" do
      expect(ram.display_name).to match("Ram")
    end

    it "start_session" do
      skip
    end

    it "end_session" do
      skip
    end

    it "generate_reset_password_token" do
      expect(ram.reset_password_token).to be_nil
      expect(ram.reset_password_sent_at).to be_nil

      ram.generate_reset_password_token
      expect(ram.reset_password_token).not_to be_nil
      expect(ram.reset_password_sent_at).not_to be_nil
    end

    it "default_image_url" do
      new_user = FactoryGirl.build(:pending_user)
      expect(new_user.default_image_url).to match("/assets/kuppayam/defaults/user-medium.png")
      expect(new_user.default_image_url("large")).to match("/assets/kuppayam/defaults/user-large.png")
    end

    it "set_permission & verify permission methods" do
      authorised_user = FactoryGirl.create(:approved_user)
      product_feature = FactoryGirl.create(:feature, name: "Products")
      
      authorised_user.set_permission(product_feature)
      expect(authorised_user.can_create?(product_feature)).to be_falsy
      expect(authorised_user.can_read?(product_feature)).to be_truthy
      expect(authorised_user.can_update?("Products")).to be_falsy
      expect(authorised_user.can_delete?("Products")).to be_falsy

      authorised_user.set_permission("Products", can_create: true, can_update: true)
      expect(authorised_user.can_create?(product_feature)).to be_truthy
      expect(authorised_user.can_read?(product_feature)).to be_truthy
      expect(authorised_user.can_update?("Products")).to be_truthy
      expect(authorised_user.can_delete?("Products")).to be_falsy
    end

  end

  context "Private Instance Methods" do

    it "should_validate_password?" do
      skip
      new_user = FactoryGirl.build(:pending_user)
      expect(new_user.send(:should_validate_password?)).to be_truthy

      saved_user = FactoryGirl.create(:pending_user)
      binding.pry
      expect(saved_user.send(:should_validate_password?)).to be_falsy

      saved_user.password = "something"
      expect(saved_user.send(:should_validate_password?)).to be_truthy
    end

    it "generate_auth_token" do
      new_user = FactoryGirl.build(:pending_user)
      new_user.auth_token = nil
      new_user.send :generate_auth_token
      expect(new_user.auth_token).not_to be_nil
    end

  end

end