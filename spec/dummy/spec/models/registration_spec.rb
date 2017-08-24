require 'spec_helper'

RSpec.describe Registration, type: :model do

  let(:registration) {FactoryGirl.build(:registration)}
  
  context "Factory" do
    it "should validate all the factories" do
      expect(FactoryGirl.build(:registration).valid?).to be true

      pending_registration = FactoryGirl.build(:pending_registration)
      expect(pending_registration.status).to match("pending")
      expect(pending_registration.valid?).to be true

      verified_registration = FactoryGirl.build(:verified_registration)
      expect(verified_registration.status).to match("verified")
      expect(verified_registration.valid?).to be true
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
  end

  context "Class Methods" do
    it "search" do

      registration

      user = FactoryGirl.create(:user, name: "Mahathma Gandhi")
      mg = FactoryGirl.create(:registration, user: user, mobile_number: "123412345")

      user = FactoryGirl.create(:user, name: "Sardar Patel")
      sp = FactoryGirl.create(:registration, user: user, mobile_number: "123456789")

      expect(Registration.search("Mahathma")).to match_array([mg])
      expect(Registration.search("Patel")).to match_array([sp])

      expect(Registration.search("123412345")).to match_array([mg])
      expect(Registration.search("123456789")).to match_array([sp])
      expect(Registration.search("1234")).to match_array([mg, sp])
    end

    it "scope pending" do
      pending_registration = FactoryGirl.create(:pending_registration)
      expect(Registration.pending.all).to match_array [pending_registration]
    end

    it "scope verified" do
      verified_registration = FactoryGirl.create(:verified_registration)
      expect(Registration.verified.all).to match_array [verified_registration]
    end
  end

  context "Instance Methods" do
    context "Status Methods" do
      it "pending!" do
        u = FactoryGirl.create(:verified_registration)
        u.pending!
        expect(u.status).to match "pending"
        expect(u.pending?).to be_truthy
      end

      it "verify!" do
        u = FactoryGirl.create(:pending_registration)
        u.verify!
        expect(u.status).to match "verified"
        expect(u.verified?).to be_truthy
      end
    end
    context "Other Methods" do
      it "as_json" do
        skip "To Be Implemented"
      end
      it "display_name" do
        r = FactoryGirl.create(:registration, dialing_prefix: "+961", mobile_number: "123412345")
        expect(r.display_name).to match("+961 123412345")
      end
    end
  end
end