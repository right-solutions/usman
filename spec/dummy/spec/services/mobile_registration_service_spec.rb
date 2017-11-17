require 'rails_helper'

describe Usman::MobileRegistrationService do

  # Registration & Device details without User (new registration case)
  let(:country) {FactoryGirl.create(:country)}
  let(:region) {FactoryGirl.create(:region, country: country)}
  let(:city) {FactoryGirl.create(:city, region: region)}
  let(:reg1) {FactoryGirl.build(:verified_registration, user: nil, city: city, country: country)}
  let(:dev1) {FactoryGirl.build(:pending_device, user: nil, registration: reg1)}
  let(:params_1) {
                   { dialing_prefix: reg1.dialing_prefix, 
                      mobile_number: reg1.mobile_number,
                      country_id: reg1.country_id,
                      city_id: reg1.city_id,
                      uuid: dev1.uuid,
                      device_token: dev1.device_token,
                      device_name: dev1.device_name,
                      device_type: dev1.device_type,
                      operating_system: dev1.operating_system,
                      software_version: dev1.software_version,
                      remote_ip: "1.2.3.4" 
                    } 
                  }
  # Existing Registration with no device details
  let(:reg2) {FactoryGirl.create(:verified_registration, city: city, country: country)}
  let(:dev2) {FactoryGirl.build(:pending_device, registration: reg2)}
  let(:params_2) {
                   { dialing_prefix: reg2.dialing_prefix, 
                      mobile_number: reg2.mobile_number,
                      country_id: reg2.country_id,
                      city_id: reg2.city_id,
                      uuid: dev2.uuid,
                      device_token: dev2.device_token,
                      device_name: dev2.device_name,
                      device_type: dev2.device_type,
                      operating_system: dev2.operating_system,
                      software_version: dev2.software_version,
                      remote_ip: "1.2.3.4" 
                    } 
                  }

  # Existing Registration with device details
  let(:dev3) {FactoryGirl.create(:device, registration: reg2)}
  let(:dev4) {FactoryGirl.create(:device, registration: reg2, uuid: "99813791")}
  let(:params_3) {
                   { dialing_prefix: reg2.dialing_prefix, 
                      mobile_number: reg2.mobile_number,
                      country_id: reg2.country_id,
                      city_id: reg2.city_id,
                      uuid: dev3.uuid,
                      device_token: dev3.device_token,
                      device_name: dev3.device_name,
                      device_type: dev3.device_type,
                      operating_system: dev3.operating_system,
                      software_version: dev3.software_version,
                      remote_ip: "1.2.3.4" 
                    } 
                  }

  describe 'initialize' do

    context 'Positive Cases' do
      it "should register and add a new device and create a dummy user" do

        mrs = Usman::MobileRegistrationService.new(params_1)
        
        expect(mrs.dialing_prefix).to eq(reg1.dialing_prefix)
        expect(mrs.mobile_number).to eq(reg1.mobile_number)
        expect(mrs.country).to eq(reg1.country)
        expect(mrs.city).to eq(reg1.city)
        expect(mrs.uuid).to eq(dev1.uuid)
        expect(mrs.device_token).to eq(dev1.device_token)
        expect(mrs.device_name).to eq(dev1.device_name)
        expect(mrs.device_type).to eq(dev1.device_type)
        expect(mrs.operating_system).to eq(dev1.operating_system)
        expect(mrs.software_version).to eq(dev1.software_version)
        expect(mrs.remote_ip).to eq("1.2.3.4")

        expect(mrs.error_message).to be_nil
        expect(mrs.error_details).to be_empty

        r = mrs.registration
        d = mrs.device.reload

        expect(r.persisted?).to be_truthy
        expect(r.dialing_prefix).to eq(reg1.dialing_prefix)
        expect(r.mobile_number).to eq(reg1.mobile_number)
        expect(r.country).to eq(reg1.country)
        expect(r.city).to eq(reg1.city)

        expect(r.user).not_to be_nil

        expect(d.persisted?).to be_truthy
        expect(d.uuid).to eq(dev1.uuid)
        expect(d.device_token).to eq(dev1.device_token)
        expect(d.device_name).to eq(dev1.device_name)
        expect(d.device_type).to eq(dev1.device_type)
        expect(d.operating_system).to eq(dev1.operating_system)
        expect(d.software_version).to eq(dev1.software_version)
        expect(d.registration.persisted?).to be_truthy
        expect(d.user).to eq(r.user)
        expect(d.otp).not_to be_nil
        expect(d.otp_sent_at).not_to be_nil
      end

      it "should register and reuse an existing device information" do

        mrs = Usman::MobileRegistrationService.new(params_2)
        
        expect(mrs.dialing_prefix).to eq(reg2.dialing_prefix)
        expect(mrs.mobile_number).to eq(reg2.mobile_number)
        expect(mrs.country).to eq(reg2.country)
        expect(mrs.city).to eq(reg2.city)
        expect(mrs.uuid).to eq(dev2.uuid)
        expect(mrs.device_token).to eq(dev2.device_token)
        expect(mrs.device_name).to eq(dev2.device_name)
        expect(mrs.device_type).to eq(dev2.device_type)
        expect(mrs.operating_system).to eq(dev2.operating_system)
        expect(mrs.software_version).to eq(dev2.software_version)
        expect(mrs.remote_ip).to eq("1.2.3.4")
        
        expect(mrs.error_heading).to be_nil
        expect(mrs.error_message).to be_nil
        expect(mrs.error_details).to be_empty

        r = mrs.registration
        d = mrs.device

        expect(r).to eq(reg2)
        expect(r.persisted?).to be_truthy
        expect(r.dialing_prefix).to eq(reg2.dialing_prefix)
        expect(r.mobile_number).to eq(reg2.mobile_number)
        expect(r.country).to eq(reg2.country)
        expect(r.city).to eq(reg2.city)
        expect(r.user.persisted?).to be_truthy

        expect(d.persisted?).to be_truthy
        expect(d.uuid).to eq(dev2.uuid)
        expect(d.device_token).to eq(dev2.device_token)
        expect(d.device_name).to eq(dev2.device_name)
        expect(d.device_type).to eq(dev2.device_type)
        expect(d.operating_system).to eq(dev2.operating_system)
        expect(d.software_version).to eq(dev2.software_version)
        expect(d.registration.persisted?).to be_truthy
        expect(d.user).to eq(r.user)
        expect(d.otp).not_to be_nil
        expect(d.otp_sent_at).not_to be_nil
      end

      it "should reuse existing registration & device information" do

        mrs = Usman::MobileRegistrationService.new(params_3)
        
        expect(mrs.dialing_prefix).to eq(reg2.dialing_prefix)
        expect(mrs.mobile_number).to eq(reg2.mobile_number)
        expect(mrs.country).to eq(reg2.country)
        expect(mrs.city).to eq(reg2.city)
        expect(mrs.uuid).to eq(dev3.uuid)
        expect(mrs.device_token).to eq(dev3.device_token)
        expect(mrs.device_name).to eq(dev3.device_name)
        expect(mrs.device_type).to eq(dev3.device_type)
        expect(mrs.operating_system).to eq(dev3.operating_system)
        expect(mrs.software_version).to eq(dev3.software_version)
        expect(mrs.remote_ip).to eq("1.2.3.4")
        
        expect(mrs.error_heading).to be_nil
        expect(mrs.error_message).to be_nil
        expect(mrs.error_details).to be_empty

        r = mrs.registration
        d = mrs.device

        expect(r).to eq(reg2)
        expect(r.persisted?).to be_truthy
        expect(r.dialing_prefix).to eq(reg2.dialing_prefix)
        expect(r.mobile_number).to eq(reg2.mobile_number)
        expect(r.country).to eq(reg2.country)
        expect(r.city).to eq(reg2.city)
        expect(r.user.persisted?).to be_truthy

        expect(d).to eq(dev3)
        expect(d.persisted?).to be_truthy
        expect(d.uuid).to eq(dev3.uuid)
        expect(d.device_token).to eq(dev3.device_token)
        expect(d.device_name).to eq(dev3.device_name)
        expect(d.device_type).to eq(dev3.device_type)
        expect(d.operating_system).to eq(dev3.operating_system)
        expect(d.software_version).to eq(dev3.software_version)
        expect(d.registration.persisted?).to be_truthy
        expect(d.user).to eq(r.user)
        expect(d.otp).not_to be_nil
        expect(d.otp_sent_at).not_to be_nil
      end

      it "should should not create a dummy user if it already has one" do
        
        mrs = Usman::MobileRegistrationService.new(params_3)
        
        expect(mrs.dialing_prefix).to eq(reg1.dialing_prefix)
        expect(mrs.mobile_number).to eq(reg1.mobile_number)
        expect(mrs.country).to eq(reg1.country)
        expect(mrs.city).to eq(reg1.city)
        expect(mrs.uuid).to eq(dev3.uuid)
        expect(mrs.device_token).to eq(dev3.device_token)
        expect(mrs.device_name).to eq(dev3.device_name)
        expect(mrs.device_type).to eq(dev3.device_type)
        expect(mrs.operating_system).to eq(dev3.operating_system)
        expect(mrs.software_version).to eq(dev3.software_version)
        expect(mrs.remote_ip).to eq("1.2.3.4")
        
        expect(mrs.error_message).to be_nil
        expect(mrs.error_details).to be_empty

        r = mrs.registration
        d = mrs.device

        expect(r.persisted?).to be_truthy
        expect(r.dialing_prefix).to eq(reg1.dialing_prefix)
        expect(r.mobile_number).to eq(reg1.mobile_number)
        expect(r.country).to eq(reg1.country)
        expect(r.city).to eq(reg1.city)

        expect(r.user).not_to be_nil

        expect(d.persisted?).to be_truthy
        expect(d.uuid).to eq(dev3.uuid)
        expect(d.device_token).to eq(dev3.device_token)
        expect(d.device_name).to eq(dev3.device_name)
        expect(d.device_type).to eq(dev3.device_type)
        expect(d.operating_system).to eq(dev3.operating_system)
        expect(d.software_version).to eq(dev3.software_version)
        expect(d.registration.persisted?).to be_truthy
        expect(d.user).to eq(r.user)
        expect(d.otp).not_to be_nil
        expect(d.otp_sent_at).not_to be_nil
      end
    end

    context 'Negative Cases' do
      it "should set proper errors if no input is given" do

        mrs = Usman::MobileRegistrationService.new({})

        expect(mrs.dialing_prefix).to be_nil
        expect(mrs.mobile_number).to be_nil
        expect(mrs.country).to be_nil
        expect(mrs.city).to be_nil
        expect(mrs.uuid).to be_nil
        expect(mrs.device_token).to be_nil
        expect(mrs.device_name).to be_nil
        expect(mrs.device_type).to be_nil
        expect(mrs.operating_system).to be_nil
        expect(mrs.software_version).to be_nil
        expect(mrs.remote_ip).to be_nil

        expect(mrs.error_heading).to match("Registring new mobile number FAILED")
        expect(mrs.error_message).to match("Check if all mandatory details are passed. Refer the error details for technical information")
        expect(mrs.error_details).not_to be_empty
        
        expect(mrs.registration.persisted?).to be_falsy
        expect(mrs.device.persisted?).to be_falsy
      end

      it "should set proper errors when device information is missing" do

        mrs = Usman::MobileRegistrationService.new({ dialing_prefix: "+91", 
                          mobile_number: "1020300103",
                          country_id: country.id
                        })

        expect(mrs.dialing_prefix).to eq("+91")
        expect(mrs.mobile_number).to eq("1020300103")
        expect(mrs.country).to eq(country)
        expect(mrs.city).to be_nil
        expect(mrs.uuid).to be_nil
        expect(mrs.device_token).to be_nil
        expect(mrs.device_name).to be_nil
        expect(mrs.device_type).to be_nil
        expect(mrs.operating_system).to be_nil
        expect(mrs.software_version).to be_nil
        expect(mrs.remote_ip).to be_nil

        expect(mrs.error_heading).to match("Registring new mobile number FAILED")
        expect(mrs.error_message).to match("Check if all mandatory details are passed. Refer the error details for technical information")
        expect(mrs.error_details).not_to be_empty
        expect(mrs.registration.persisted?).to be_falsy
        expect(mrs.device.persisted?).to be_falsy

        # If country selected is invalid
        mrs = Usman::MobileRegistrationService.new({ dialing_prefix: "+91", 
                          mobile_number: "1020300103",
                          country_id: 1234
                        })

        expect(mrs.dialing_prefix).to eq("+91")
        expect(mrs.mobile_number).to eq("1020300103")
        expect(mrs.country).to eq(nil)
      end

      it "should set proper errors when registration information is missing" do

        mrs = Usman::MobileRegistrationService.new({ 
                          uuid: "1823891239",
                          device_token: "2392342346287649234"
                        })

        expect(mrs.dialing_prefix).to be_nil
        expect(mrs.mobile_number).to be_nil
        expect(mrs.country).to be_nil
        expect(mrs.city).to be_nil
        expect(mrs.uuid).to match("1823891239")
        expect(mrs.device_token).to match("2392342346287649234")
        expect(mrs.device_name).to be_nil
        expect(mrs.device_type).to be_nil
        expect(mrs.operating_system).to be_nil
        expect(mrs.software_version).to be_nil
        expect(mrs.remote_ip).to be_nil

        expect(mrs.error_heading).to match("Registring new mobile number FAILED")
        expect(mrs.error_message).to match("Check if all mandatory details are passed. Refer the error details for technical information")
        expect(mrs.error_details).not_to be_empty

        expect(mrs.registration.persisted?).to be_falsy
        expect(mrs.device.persisted?).to be_falsy
      end

      it "should set proper errors for device is blocked" do

        blocked_dev = FactoryGirl.create(:blocked_device, user: nil, registration: reg1)
        mrs = Usman::MobileRegistrationService.new({ 
                          dialing_prefix: reg1.dialing_prefix, 
                          mobile_number: reg1.mobile_number,
                          country_id: reg1.country_id,
                          city_id: reg1.city_id,
                          uuid: blocked_dev.uuid,
                          device_token: blocked_dev.device_token,
                          device_name: blocked_dev.device_name,
                          device_type: blocked_dev.device_type,
                          operating_system: blocked_dev.operating_system,
                          software_version: blocked_dev.software_version,
                          remote_ip: "1.2.3.4" 
                        })

        expect(mrs.dialing_prefix).to eq(reg1.dialing_prefix)
        expect(mrs.mobile_number).to eq(reg1.mobile_number)
        expect(mrs.country).to eq(reg1.country)
        expect(mrs.city).to eq(reg1.city)
        expect(mrs.uuid).to eq(blocked_dev.uuid)
        expect(mrs.device_token).to eq(blocked_dev.device_token)
        expect(mrs.device_name).to eq(blocked_dev.device_name)
        expect(mrs.device_type).to eq(blocked_dev.device_type)
        expect(mrs.operating_system).to eq(blocked_dev.operating_system)
        expect(mrs.software_version).to eq(blocked_dev.software_version)
        expect(mrs.remote_ip).to eq("1.2.3.4")

        expect(mrs.error_heading).to match("This device is blocked")
        expect(mrs.error_message).to match("You must have done some mal-practices")
        expect(mrs.error_details).to be_empty

        expect(mrs.registration.persisted?).to be_truthy
        expect(mrs.device.persisted?).to be_truthy
      end
    end

  end
end