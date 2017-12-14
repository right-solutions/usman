require 'spec_helper'

RSpec.describe Registration, type: :model do

  let(:registration) {FactoryBot.build(:registration)}
  
  context "Factory" do
    it "should validate all the factories" do
      expect(FactoryBot.build(:registration).valid?).to be_truthy
      
      reg = FactoryBot.create(:registration)
      expect(reg.valid?).to be_truthy
      expect(reg.city).not_to be_nil
      expect(reg.country).not_to be_nil
      expect(reg.city.country).to eq(reg.country)

      pending_registration = FactoryBot.build(:pending_registration)
      expect(pending_registration.status).to match("pending")
      expect(pending_registration.valid?).to be_truthy

      verified_registration = FactoryBot.build(:verified_registration)
      expect(verified_registration.status).to match("verified")
      expect(verified_registration.valid?).to be_truthy

      suspended_registration = FactoryBot.build(:suspended_registration)
      expect(suspended_registration.status).to match("suspended")
      expect(suspended_registration.valid?).to be_truthy
    end
  end

  context "Validations" do
    it { should validate_presence_of :dialing_prefix }
    it { should allow_value("+971").for(:dialing_prefix )}
    it { should_not allow_value("1").for(:dialing_prefix )}
    it { should_not allow_value("+1234").for(:dialing_prefix )}

    it { should validate_presence_of :mobile_number }
    it { should allow_value("501234567").for(:mobile_number )}
    it { should allow_value("5012345678").for(:mobile_number )}
    it { should allow_value("50123456789").for(:mobile_number )}
    it { should_not allow_value("50123456").for(:mobile_number )}
    it { should_not allow_value("501234567123").for(:mobile_number )}

    it { should validate_inclusion_of(:status).in_array(Registration::STATUS.keys)  }
  end

  context "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:country) }
    it { should belong_to(:city) }
    it { should have_many(:devices) }
    it { should have_many(:contacts) }
  end

  context "Class Methods" do
    it "search" do
      registration

      user = FactoryBot.create(:user, name: "Mahathma Gandhi")
      mg = FactoryBot.create(:registration, user: user, mobile_number: "123412345")

      user = FactoryBot.create(:user, name: "Sardar Patel")
      sp = FactoryBot.create(:registration, user: user, mobile_number: "123456789")

      expect(Registration.search("Mahathma")).to match_array([mg])
      expect(Registration.search("Patel")).to match_array([sp])

      expect(Registration.search("123412345")).to match_array([mg])
      expect(Registration.search("123456789")).to match_array([sp])
      expect(Registration.search("1234")).to match_array([mg, sp])
    end

    it "search registrations without user" do
      u = FactoryBot.create(:pending_registration, user: nil, mobile_number: "123412345")
      expect(Registration.search("123412345")).to match_array([u])
    end

    it "scope pending" do
      pending_registration = FactoryBot.create(:pending_registration)
      expect(Registration.pending.all).to match_array [pending_registration]
    end

    it "scope verified" do
      verified_registration = FactoryBot.create(:verified_registration)
      expect(Registration.verified.all).to match_array [verified_registration]
    end
  end

  context "Instance Methods" do
    context "Status Methods" do
      it "pending!" do
        r = FactoryBot.create(:verified_registration)
        r.pending!
        expect(r.status).to match "pending"
        expect(r.pending?).to be_truthy
        expect(r.user.pending?).to be_truthy

        # If user is nil
        r = FactoryBot.create(:verified_registration, user: nil)
        r.pending!
        expect(r.status).to match "pending"
        expect(r.pending?).to be_truthy
        expect(r.user).to be_nil
      end

      it "verify!" do
        u = FactoryBot.create(:pending_registration)
        u.verify!
        expect(u.status).to match "verified"
        expect(u.verified?).to be_truthy

        # If user is nil
        r = FactoryBot.create(:pending_registration, user: nil)
        r.verify!
        expect(r.status).to match "verified"
        expect(r.verified?).to be_truthy
        expect(r.user).to be_nil
      end

      it "suspend!" do
        u = FactoryBot.create(:verified_registration)
        u.suspend!
        expect(u.status).to match "suspended"
        expect(u.suspended?).to be_truthy

        # If user is nil
        r = FactoryBot.create(:pending_registration, user: nil)
        r.suspend!
        expect(r.status).to match "suspended"
        expect(r.suspended?).to be_truthy
        expect(r.user).to be_nil
      end

      it "delete!" do
        u = FactoryBot.create(:verified_registration)
        u.delete!
        expect(u.status).to match "deleted"
        expect(u.deleted?).to be_truthy

        # If user is nil
        r = FactoryBot.create(:pending_registration, user: nil)
        r.delete!
        expect(r.status).to match "deleted"
        expect(r.deleted?).to be_truthy
        expect(r.user).to be_nil
      end
    end
    context "Other Methods" do
      it "as_json" do
        skip "To Be Implemented"
      end
      it "display_name" do
        r = FactoryBot.create(:registration, dialing_prefix: "+961", mobile_number: "123412345")
        expect(r.display_name).to match("+961 123412345")
      end
    end
  end
end