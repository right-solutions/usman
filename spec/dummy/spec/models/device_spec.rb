require 'spec_helper'

RSpec.describe Device, type: :model do

  let(:device) {FactoryBot.build(:device)}
  
  context "Factory" do
    it "should validate all the factories" do
      expect(FactoryBot.build(:device).valid?).to be_truthy

      pending_device = FactoryBot.build(:pending_device)
      expect(pending_device.status).to match("pending")
      expect(pending_device.valid?).to be_truthy

      verified_device = FactoryBot.build(:verified_device)
      expect(verified_device.status).to match("verified")
      expect(verified_device.valid?).to be_truthy

      blocked_device = FactoryBot.build(:blocked_device)
      expect(blocked_device.status).to match("blocked")
      expect(blocked_device.valid?).to be_truthy
    end
  end

  context "Validations" do
    it { should validate_presence_of :uuid }
    it { should allow_value("x"*1024).for(:uuid )}
    it { should allow_value("39-48-5037458473").for(:uuid )}
    it { should_not allow_value("x"*1025).for(:uuid )}

    it { should validate_presence_of :device_token }
    it { should allow_value("x"*1024).for(:device_token )}
    it { should allow_value("18926386123123").for(:device_token )}
    it { should_not allow_value("x"*1025).for(:device_token )}

    it { should allow_value(nil).for(:device_name) }
    it { should allow_value("x"*64).for(:device_name )}
    it { should allow_value("Samsung Note").for(:device_name )}
    it { should_not allow_value("x"*65).for(:device_name )}

    it { should allow_value(nil).for(:device_type) }
    it { should allow_value("x"*64).for(:device_type )}
    it { should allow_value("Note 7").for(:device_type )}
    it { should_not allow_value("x"*65).for(:device_type )}

    it { should allow_value(nil).for(:operating_system) }
    it { should allow_value("x"*64).for(:operating_system )}
    it { should allow_value("Android").for(:operating_system )}
    it { should_not allow_value("x"*65).for(:operating_system )}

    it { should allow_value(nil).for(:software_version) }
    it { should allow_value("x"*64).for(:software_version )}
    it { should allow_value("Icecream").for(:software_version )}
    it { should_not allow_value("x"*65).for(:software_version )}

    it { should allow_value(nil).for(:last_accessed_api) }
    it { should allow_value("x"*1024).for(:last_accessed_api )}
    it { should allow_value("/api/v1/register").for(:last_accessed_api )}
    it { should_not allow_value("x"*1025).for(:last_accessed_api )}

    it { should allow_value(nil).for(:otp) }
    it { should allow_value(12345).for(:otp )}
    it { should_not allow_value(12).for(:otp )}
    it { should_not allow_value(123456).for(:otp )}

    it { should allow_value(nil).for(:api_token) }
    it { should allow_value("x"*256).for(:api_token )}
    it { should allow_value("5012345678").for(:api_token )}
    it { should_not allow_value("x"*257).for(:api_token )}
    
    it { should validate_inclusion_of(:status).in_array(Device::STATUS.keys)  }
  end

  context "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:registration) }
    it { should have_many(:contacts) }
  end

  context "Class Methods" do
    it "search" do

      device

      user = FactoryBot.create(:user, name: "Mahathma Gandhi")
      mgr = FactoryBot.create(:registration, user: user, mobile_number: "123412345")
      mgd = FactoryBot.create(:device, user: user, registration: mgr, uuid: "1324", device_token: "6879", device_name: "Samsung Note", device_type: "Samsung Note 7")

      user = FactoryBot.create(:user, name: "Sardar Patel")
      spr = FactoryBot.create(:registration, user: user, mobile_number: "123456789")
      spd = FactoryBot.create(:device, user: user, registration: spr, uuid: "4231", device_token: "9786", device_name: "Nexus 7", device_type: "Nexus 7 Series")

      expect(Device.search("Mahathma")).to match_array([mgd])
      expect(Device.search("123412345")).to match_array([mgd])
      expect(Device.search("1324")).to match_array([mgd])
      expect(Device.search("6879")).to match_array([mgd])
      expect(Device.search("Samsung Note")).to match_array([mgd])
      expect(Device.search("Note 7")).to match_array([mgd])

      expect(Device.search("Patel")).to match_array([spd])
      expect(Device.search("123456789")).to match_array([spd])
      expect(Device.search("4231")).to match_array([spd])
      expect(Device.search("9786")).to match_array([spd])
      expect(Device.search("Nexus 7")).to match_array([spd])
      expect(Device.search("7 Series")).to match_array([spd])

      expect(Device.search("1234")).to match_array([mgd, spd])
    end

    it "scope pending" do
      pending_device = FactoryBot.create(:pending_device)
      expect(Device.pending.all).to match_array [pending_device]
    end

    it "scope verified" do
      verified_device = FactoryBot.create(:verified_device)
      expect(Device.verified.all).to match_array [verified_device]
    end

    it "scope blocked" do
      blocked_device = FactoryBot.create(:blocked_device)
      expect(Device.blocked.all).to match_array [blocked_device]
    end
  end

  context "Instance Methods" do

    context "Status Methods" do

      it "pending!" do
        u = FactoryBot.create(:verified_device)
        u.pending!
        expect(u.status).to match "pending"
        expect(u.pending?).to be_truthy
      end

      it "verify!" do
        u = FactoryBot.create(:pending_device)
        u.verify!
        expect(u.status).to match "verified"
        expect(u.verified?).to be_truthy
      end

      it "block!" do
        u = FactoryBot.create(:verified_device)
        u.block!
        expect(u.status).to match "blocked"
        expect(u.blocked?).to be_truthy
      end
    end

    context "Authentication Methods" do
      it "generate_otp" do
        device.generate_otp
        expect(device.otp).not_to be_nil
      end

      it "validate_otp" do
        skip "To Be Implemented"
      end

      it "send_otp" do
        expect(device.send_otp).to eq(true)
      end
    end

    context "Other Methods" do
      it "as_json" do
        # If verified, it should return api token
        reg = FactoryBot.create(:verified_registration)
        dev = FactoryBot.create(:verified_device, registration: reg)

        expect(dev.as_json["api_token"]).to be_blank
        expect(dev.as_json["status"]).to eq("verified")

        # If pending or blocked, it should not return api token
        reg = FactoryBot.create(:pending_registration)
        dev = FactoryBot.create(:pending_device, registration: reg)

        expect(dev.as_json["api_token"]).to be_blank
        expect(dev.as_json["status"]).to eq("pending")

        # If pending or blocked, it should not return api token
        reg = FactoryBot.create(:verified_registration)
        dev = FactoryBot.create(:blocked_device, registration: reg)

        expect(dev.as_json["api_token"]).to be_blank
        expect(dev.as_json["status"]).to eq("blocked")
      end
      it "display_name" do
        r = FactoryBot.create(:device, device_name: "Samsung Galaxy", uuid: "1234567890")
        expect(r.display_name).to match("Samsung Galaxy - 1234567890")
      end
    end
  end
end