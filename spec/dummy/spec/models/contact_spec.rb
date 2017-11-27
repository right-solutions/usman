require 'spec_helper'

RSpec.describe Usman::Contact, type: :model do

  let(:contact) {FactoryGirl.build(:contact)}
  
  context "Factory" do
    it "should validate all the factories" do
      expect(FactoryGirl.build(:contact).valid?).to be_truthy
    end
  end

  context "Validations" do
    it { should validate_presence_of :name }
    it { should allow_value("x"*512).for(:name )}
    it { should allow_value("Some Name").for(:name )}
    it { should_not allow_value("x"*513).for(:name )}

    it { should allow_value(nil).for(:account_type) }
    it { should allow_value("com.google").for(:account_type )}
    it { should_not allow_value("x"*257).for(:account_type )}

    it { should validate_presence_of :email }
    it { should allow_value('something@domain.com').for(:email )}
    it { should_not allow_value('something domain.com').for(:email )}
    it { should_not allow_value('something.domain.com').for(:email )}
    it { should_not allow_value('ED').for(:email )}
    it { should_not allow_value("x"*257).for(:email )}

    it { should allow_value(nil).for(:address) }
    it { should allow_value("Some Address").for(:address )}
    it { should_not allow_value("x"*513).for(:address )}

    it { should validate_presence_of :contact_number_1 }
    it { should allow_value("1"*24).for(:contact_number_1 )}
    it { should allow_value("1234567890").for(:contact_number_1 )}
    it { should_not allow_value("x"*25).for(:contact_number_1 )}

    it { should allow_value(nil).for(:contact_number_2) }
    it { should allow_value("1234567890").for(:contact_number_2 )}
    it { should_not allow_value("x"*25).for(:contact_number_2 )}

    it { should allow_value(nil).for(:contact_number_3) }
    it { should allow_value("1234567890").for(:contact_number_3 )}
    it { should_not allow_value("x"*25).for(:contact_number_3 )}

    it { should allow_value(nil).for(:contact_number_4) }
    it { should allow_value("1234567890").for(:contact_number_4 )}
    it { should_not allow_value("x"*25).for(:contact_number_4 )}
  end

  context "Associations" do
    it { should belong_to(:owner) }
    it { should belong_to(:done_deal_user) }
    it { should belong_to(:registration) }
    it { should belong_to(:device) }
  end

  context "Class Methods" do
    it "search" do

      mkg = FactoryGirl.create(:contact, name: "Mohandas Karamchand Gandhi", email: "gandhi@india.com", contact_number_1: "1234123412", account_type: "com.google")
      svp = FactoryGirl.create(:contact, name: "Sardar Vallabhai Patel", email: "sardar.patel@india.com", contact_number_1: "4567456745", account_type: "com.google")
      
      expect(Usman::Contact.search("Mohandas")).to match_array([mkg])
      expect(Usman::Contact.search("gandhi@india.com")).to match_array([mkg])
      expect(Usman::Contact.search("1234123412")).to match_array([mkg])
      
      expect(Usman::Contact.search("Patel")).to match_array([svp])
      expect(Usman::Contact.search("sardar.patel@india.com")).to match_array([svp])
      expect(Usman::Contact.search("4567456745")).to match_array([svp])

      expect(Usman::Contact.search("com.google")).to match_array([mkg, svp])
    end
  end

  context "Instance Methods" do
    context "Other Methods" do
      it "display_name" do
        c = FactoryGirl.create(:contact, name: "Rama Krishnan")
        expect(c.display_name).to match("Rama Krishnan")
      end

      it "get_done_deal_user" do
        mohanlal = FactoryGirl.create(:user, name: "Mohanlal")
        reg = FactoryGirl.create(:verified_registration, user: mohanlal, dialing_prefix: "+91", mobile_number: "9880123123")
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        mammotty = FactoryGirl.create(:user, name: "Mammotty")
        reg = FactoryGirl.create(:verified_registration, user: mammotty, dialing_prefix: "+92", mobile_number: "9880123123")
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        shobhana = FactoryGirl.create(:user, name: "Shobhana")
        reg = FactoryGirl.create(:verified_registration, user: shobhana, dialing_prefix: "+971", mobile_number: "9880123123")
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)

        seetha = FactoryGirl.create(:user, name: "Seetha")
        reg = FactoryGirl.create(:verified_registration, user: seetha, dialing_prefix: "+91", mobile_number: "9880234234")
        dev = FactoryGirl.create(:verified_device, registration: reg, api_token: SecureRandom.hex)
        
        contact = FactoryGirl.build(:contact, name: "Lalettan", email: "mohanlal@mollywood.com", account_type: "com.mollywood", contact_number_1: "+919880123123", contact_number_2: "2234234234", contact_number_3: "3234234234", contact_number_4: "4234234234")
        ddo = contact.get_done_deal_user
        expect(ddo).to eq(mohanlal)

        contact = FactoryGirl.build(:contact, name: "Mammukka", email: "mammotty@mollywood.com", account_type: "com.mollywood", contact_number_1: "+9719880123123", contact_number_2: "+929880123123", contact_number_3: "3234234234", contact_number_4: "4234234234")
        ddo = contact.get_done_deal_user
        expect(ddo).to eq(mammotty)
      end
    end
  end
end