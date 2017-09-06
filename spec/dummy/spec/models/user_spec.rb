require 'spec_helper'

RSpec.describe User, type: :model do

  let(:user) {FactoryGirl.build(:user)}
  let(:ram) {FactoryGirl.create(:user, name: "Ram", email: "ram@domain.com", username: "ram1234", designation: "Prince")}
  let(:lakshman) {FactoryGirl.create(:user, name: "Lakshman", email: "lakshmanword@domain.com", username: "lakshman1234", designation: "Prince")}
  let(:sita) {FactoryGirl.create(:user, name: "Sita", email: "sita@domain.com", username: "sita1234word", designation: "Princess")}

  context "Factory" do
    it "should validate all the factories" do
      expect(FactoryGirl.build(:user).valid?).to be_truthy

      pending_user = FactoryGirl.build(:pending_user)
      expect(pending_user.status).to match("pending")
      expect(pending_user.valid?).to be_truthy

      approved_user = FactoryGirl.build(:approved_user)
      expect(approved_user.status).to match("approved")
      expect(approved_user.valid?).to be_truthy

      suspended_user = FactoryGirl.build(:suspended_user)
      expect(suspended_user.status).to match("suspended")
      expect(suspended_user.valid?).to be_truthy

      super_admin_user = FactoryGirl.build(:super_admin_user)
      expect(super_admin_user.super_admin).to be_truthy
      expect(super_admin_user.valid?).to be_truthy
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

    it { should validate_inclusion_of(:status).in_array(User::STATUS.keys)  }
    it { should validate_inclusion_of(:gender).in_array(User::GENDER.keys)  }
  end

  context "Associations" do
    it { should have_one(:profile_picture) }
    it { should have_many(:permissions) }
    it { should have_many(:features) }
    it { should have_one(:registration) }
    it { should have_many(:devices) }
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

    context "Import Methods" do
      it "save_row_data" do
        skip "To Be Implemented"
      end
    end
  end

  context "Instance Methods" do

    context "Status Methods" do

      it "approve!" do
        u = FactoryGirl.create(:pending_user)
        u.approve!
        expect(u.status).to match "approved"
        expect(u.approved?).to be_truthy
      end

      it "pending!" do
        u = FactoryGirl.create(:approved_user)
        u.pending!
        expect(u.status).to match "pending"
        expect(u.pending?).to be_truthy
      end

      it "suspend!" do
        u = FactoryGirl.create(:approved_user)
        u.suspend!
        expect(u.status).to match "suspended"
        expect(u.suspended?).to be_truthy
      end
    end

    context "Gender Methods" do
      it "male?" do
        u = FactoryGirl.build(:pending_user, gender: :male)
        expect(u.gender).to match "male"
        expect(u.male?).to be_truthy
      end

      it "female?" do
        u = FactoryGirl.build(:pending_user, gender: :female)
        expect(u.gender).to match "female"
        expect(u.female?).to be_truthy
      end

      it "nogender?" do
        u = FactoryGirl.build(:pending_user, gender: :nogender)
        expect(u.gender).to match "nogender"
        expect(u.nogender?).to be_truthy
      end
    end

    context "Authentication Methods" do
      
      it "start_session and end session" do

        # Fresh user who has never started a session
        user = FactoryGirl.create(:user)

        expect(user.last_sign_in_at).to be_nil
        expect(user.last_sign_in_ip).to be_nil

        expect(user.current_sign_in_at).to be_nil
        expect(user.current_sign_in_ip).to be_nil

        expect(user.sign_in_count).to be(0)

        # Start session
        user.start_session('1.2.3.4')

        expect(user.last_sign_in_at).to be_nil
        expect(user.last_sign_in_ip).to be_nil

        expect(user.current_sign_in_at.utc.to_s).not_to be_nil
        expect(user.current_sign_in_ip).to match('1.2.3.4')

        expect(user.sign_in_count).to be(1)

        # end session
        current_sign_in_at = user.current_sign_in_at
        user.end_session

        expect(user.current_sign_in_at).to be_nil
        expect(user.current_sign_in_ip).to be_nil

        expect(user.last_sign_in_at.utc.to_s).to eq(current_sign_in_at.utc.to_s)
        expect(user.last_sign_in_ip).to match('1.2.3.4')

        # start session once again
        user.start_session('5.6.7.8')

        expect(user.last_sign_in_at.utc.to_s).to eq(current_sign_in_at.utc.to_s)
        expect(user.last_sign_in_ip).to match('1.2.3.4')

        expect(user.current_sign_in_at.utc.to_s).not_to be_nil
        expect(user.current_sign_in_ip).to match('5.6.7.8')
        expect(user.sign_in_count).to be(2)
      end

      it "generate_reset_password_token" do
        expect(ram.reset_password_token).to be_nil
        expect(ram.reset_password_sent_at).to be_nil

        ram.generate_reset_password_token
        expect(ram.reset_password_token).not_to be_nil
        expect(ram.reset_password_sent_at).not_to be_nil
      end
    end

    context "Permission Methods" do
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

    context "Role Methods" do
    end

    context "Other Methods" do
      it "as_json" do
        skip "To Be Implemented"
      end

      it "display_name" do
        expect(ram.display_name).to match("Ram")
      end

      it "default_image_url" do
        u = FactoryGirl.build(:pending_user)
        expect(u.default_image_url).to match("/assets/kuppayam/defaults/user-small.png")
        expect(u.default_image_url("large")).to match("/assets/kuppayam/defaults/user-large.png")
      end
    end
  end

  context "Private Instance Methods" do
    it "should_validate_password?" do
      new_user = FactoryGirl.build(:pending_user)
      expect(new_user.send(:should_validate_password?)).to be_truthy

      saved_user = FactoryGirl.create(:pending_user)
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