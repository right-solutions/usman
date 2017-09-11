require "rails_helper"

RSpec.describe Usman::Api::V1::RegistrationsController, :type => :request do  

  let(:country) {FactoryGirl.create(:country)}
  let(:city) {FactoryGirl.create(:city, country: country)}

  describe "register" do
    context "Positive Case" do
      it "should register and add a new device" do
        uuid = SecureRandom.hex
        device_token = SecureRandom.hex
        registration_data = {
                              country_id: country.id, 
                              city_id: city.id, 
                              dialing_prefix: "+971", 
                              mobile_number: "554455339",
                              uuid: uuid,
                              device_token: device_token,
                              device_name: "Apple iPhone",
                              device_type: "iPhone 7 Plus",
                              operating_system: "iPhone 7 Plus",
                              software_version: "Apple iOS"
                            }

        post "/api/v1/register", params: registration_data
      
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(true)
        
        expect(response_body["alert"]["heading"]).to eq("An OTP has been sent to you")
        expect(response_body["alert"]["message"]).to eq("Check your mobile for new message from us")

        data = response_body['data']

        expect(data["registration"]["id"]).not_to be_blank
        expect(data["registration"]["country_id"]).to eq(country.id)
        expect(data["registration"]["city_id"]).to eq(city.id)
        expect(data["registration"]["dialing_prefix"]).to eq("+971")
        expect(data["registration"]["mobile_number"]).to eq("554455339")
        expect(data["registration"]["user_id"]).to be_blank
        expect(data["registration"]["status"]).to match("pending")

        expect(data["device"]["user_id"]).to be_blank
        expect(data["device"]["registration_id"]).not_to be_blank
        expect(data["device"]["uuid"]).to match(uuid)
        expect(data["device"]["device_token"]).to match(device_token)
        expect(data["device"]["device_name"]).to match("Apple iPhone")
        expect(data["device"]["device_type"]).to match("iPhone 7 Plus")
        expect(data["device"]["operating_system"]).to match("iPhone 7 Plus")
        expect(data["device"]["software_version"]).to match("Apple iOS")
        expect(data["device"]["status"]).to match("pending")
        expect(data["device"]["api_token"]).to be_blank
      end

      it "should register and reuse an existing registration information" do
        reg = FactoryGirl.create(:verified_registration)
        uuid = SecureRandom.hex
        device_token = SecureRandom.hex
        registration_data = {
                              country_id: reg.country.id, 
                              city_id: reg.city.id, 
                              dialing_prefix: reg.dialing_prefix, 
                              mobile_number: reg.mobile_number,
                              uuid: uuid,
                              device_token: device_token,
                              device_name: "Apple iPhone",
                              device_type: "iPhone 7 Plus",
                              operating_system: "iPhone 7 Plus",
                              software_version: "Apple iOS"
                            }

        post "/api/v1/register", params: registration_data
      
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)
        
        expect(response_body["success"]).to eq(true)

        expect(response_body["alert"]["heading"]).to eq("An OTP has been sent to you")
        expect(response_body["alert"]["message"]).to eq("Check your mobile for new message from us")

        data = response_body['data']
        
        expect(data["registration"]["id"]).to be(reg.id)
        expect(data["registration"]["country_id"]).to eq(reg.country.id)
        expect(data["registration"]["city_id"]).to eq(reg.city.id)
        expect(data["registration"]["dialing_prefix"]).to eq(reg.dialing_prefix)
        expect(data["registration"]["mobile_number"]).to eq(reg.mobile_number)
        expect(data["registration"]["user_id"]).to eq(reg.user.id)
        expect(data["registration"]["status"]).to match("verified")
        
        expect(data["device"]["registration_id"]).to be(reg.id)
        expect(data["device"]["uuid"]).to match(uuid)
        expect(data["device"]["device_token"]).to match(device_token)
        expect(data["device"]["device_name"]).to match("Apple iPhone")
        expect(data["device"]["device_type"]).to match("iPhone 7 Plus")
        expect(data["device"]["operating_system"]).to match("iPhone 7 Plus")
        expect(data["device"]["software_version"]).to match("Apple iOS")
        expect(data["device"]["user_id"]).to be(reg.user.id)
        expect(data["device"]["status"]).to match("pending")
        expect(data["device"]["api_token"]).to be_blank
      end

      it "should reuse existing registration & device information" do
        reg = FactoryGirl.create(:verified_registration)
        dev = FactoryGirl.create(:verified_device, registration: reg, user: reg.user)
        
        registration_data = {
                              country_id: reg.country.id, 
                              city_id: reg.city.id, 
                              dialing_prefix: reg.dialing_prefix, 
                              mobile_number: reg.mobile_number,
                              uuid: dev.uuid,
                              device_token: dev.device_token,
                              device_name: dev.device_name,
                              device_type: dev.device_type,
                              operating_system: dev.operating_system,
                              software_version: dev.software_version
                            }

        post "/api/v1/register", params: registration_data
      
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(true)

        expect(response_body["alert"]["heading"]).to eq("An OTP has been sent to you")
        expect(response_body["alert"]["message"]).to eq("Check your mobile for new message from us")

        data = response_body['data']
        
        expect(data["registration"]["id"]).to be(reg.id)
        expect(data["registration"]["country_id"]).to eq(reg.country.id)
        expect(data["registration"]["city_id"]).to eq(reg.city.id)
        expect(data["registration"]["dialing_prefix"]).to eq(reg.dialing_prefix)
        expect(data["registration"]["mobile_number"]).to eq(reg.mobile_number)
        expect(data["registration"]["user_id"]).to eq(reg.user.id)
        expect(data["registration"]["status"]).to match("verified")
        
        expect(data["device"]["registration_id"]).to be(reg.id)
        expect(data["device"]["uuid"]).to match(dev.uuid)
        expect(data["device"]["device_token"]).to match(dev.device_token)
        expect(data["device"]["device_name"]).to match(dev.device_name)
        expect(data["device"]["device_type"]).to match(dev.device_type)
        expect(data["device"]["operating_system"]).to match(dev.operating_system)
        expect(data["device"]["software_version"]).to match(dev.software_version)
        expect(data["device"]["user_id"]).to be(dev.user.id)
        expect(data["device"]["status"]).to match("verified")
        expect(data["device"]["api_token"]).to be_blank
      end
    end
    context 'Negative Cases' do
      it "should set proper errors if no input is given" do
        post "/api/v1/register", params: {}
      
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(false)
        expect(response_body["data"]).to be_blank
        expect(response_body["alert"]).to be_blank

        expect(response_body["errors"]["heading"]).to eq("Registring new mobile number FAILED")
        expect(response_body["errors"]["message"]).to eq("Check if all mandatory details are passed. Refer the error details for technical information")
        expect(response_body["errors"]["details"]["country"].first).to eq("must exist")
        expect(response_body["errors"]["details"]["dialing_prefix"].first).to eq("can't be blank")
        expect(response_body["errors"]["details"]["mobile_number"].first).to eq("can't be blank")
        expect(response_body["errors"]["details"]["uuid"].first).to eq("can't be blank")
        expect(response_body["errors"]["details"]["device_token"].first).to eq("can't be blank")
      end

      it "should set proper errors when device information is missing" do
        post "/api/v1/register", params: {
                          dialing_prefix: "+91", 
                          mobile_number: "1020300103",
                          country_id: country.id }
      
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(false)
        expect(response_body["data"]).to be_blank
        expect(response_body["alert"]).to be_blank

        expect(response_body["errors"]["heading"]).to eq("Registring new mobile number FAILED")
        expect(response_body["errors"]["message"]).to eq("Check if all mandatory details are passed. Refer the error details for technical information")
        expect(response_body["errors"]["details"]["uuid"].first).to eq("can't be blank")
        expect(response_body["errors"]["details"]["device_token"].first).to eq("can't be blank")
      end

      it "should set proper errors when registration information is missing" do
        dev = FactoryGirl.build(:pending_device, registration: nil)
        post "/api/v1/register", params: {
                                            uuid: dev.uuid,
                                            device_token: dev.device_token,
                                            device_name: dev.device_name,
                                            device_type: dev.device_type,
                                            operating_system: dev.operating_system,
                                            software_version: dev.software_version,
                                          }
      
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to eq(false)
        expect(response_body["data"]).to be_blank
        expect(response_body["alert"]).to be_blank

        expect(response_body["errors"]["heading"]).to eq("Registring new mobile number FAILED")
        expect(response_body["errors"]["message"]).to eq("Check if all mandatory details are passed. Refer the error details for technical information")
        expect(response_body["errors"]["details"]["country"].first).to eq("must exist")
        expect(response_body["errors"]["details"]["dialing_prefix"].first).to eq("can't be blank")
        expect(response_body["errors"]["details"]["mobile_number"].first).to eq("can't be blank")
      end

      it "should set proper errors for device is blocked" do

        reg = FactoryGirl.create(:registration)
        dev = FactoryGirl.create(:blocked_device, registration: reg)
        post "/api/v1/register", params: {
                                            dialing_prefix: reg.dialing_prefix, 
                                            mobile_number: reg.mobile_number,
                                            country_id: reg.country_id,
                                            uuid: dev.uuid,
                                            device_token: dev.device_token,
                                            device_name: dev.device_name,
                                            device_type: dev.device_type,
                                            operating_system: dev.operating_system,
                                            software_version: dev.software_version,
                                          }
      
        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)
        
        expect(response_body["success"]).to eq(false)
        expect(response_body["data"]).to be_blank
        expect(response_body["alert"]).to be_blank

        expect(response_body["errors"]["heading"]).to eq("This device is blocked")
        expect(response_body["errors"]["message"]).to eq("You must have done some mal-practices")
        expect(response_body["errors"]["details"]).to be_empty
      end
    end
  end

  describe "resend_otp" do
    context "Positive Case" do
      it "should resend the otp for valid inputs" do
        reg = FactoryGirl.create(:registration)
        dev = FactoryGirl.create(:pending_device, registration: reg)
        post "/api/v1/resend_otp", params: {
                                          uuid: dev.uuid,
                                          dialing_prefix: reg.dialing_prefix, 
                                          mobile_number: reg.mobile_number
                                        }

        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to be(true)
        expect(response_body["errors"]).to be_blank

        expect(response_body["alert"]["heading"]).to  eq("An new OTP has been sent to you")
        expect(response_body["alert"]["message"]).to  eq("Check your mobile for new message from us")
      end
      it "should resend the otp even if the device is verified" do
        reg = FactoryGirl.create(:registration)
        dev = FactoryGirl.create(:verified_device, registration: reg)
        post "/api/v1/resend_otp", params: {
                                          uuid: dev.uuid,
                                          dialing_prefix: reg.dialing_prefix, 
                                          mobile_number: reg.mobile_number
                                        }

        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to be(true)
        expect(response_body["errors"]).to be_blank

        expect(response_body["alert"]["heading"]).to  eq("An new OTP has been sent to you")
        expect(response_body["alert"]["message"]).to  eq("Check your mobile for new message from us")
      end
    end
    context "Negative Case" do
      it "should respond with proper errors if no parameters are passed" do
        reg = FactoryGirl.create(:registration)
        dev = FactoryGirl.create(:pending_device, registration: reg)
        post "/api/v1/resend_otp", params: {}

        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)
        
        expect(response_body["success"]).to be(false)
        expect(response_body["alert"]).to be_blank

        expect(response_body["errors"]["heading"]).to  eq("The mobile number is not registered")
        expect(response_body["errors"]["message"]).to  eq("Resending OTP Failed. Check if the mobile number entered is valid")
        expect(response_body["errors"]["details"]["mobile_number"]).to  eq("is invalid")
      end

      it "should respond with proper errors if mobile number is not registered" do
        post "/api/v1/resend_otp", params: { dialing_prefix: "+91", mobile_number: "1234512345" }

        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to be(false)
        expect(response_body["alert"]).to be_blank

        expect(response_body["errors"]["heading"]).to  eq("The mobile number is not registered")
        expect(response_body["errors"]["message"]).to  eq("Resending OTP Failed. Check if the mobile number entered is valid")
        expect(response_body["errors"]["details"]["mobile_number"]).to  eq("is invalid")
      end

      it "should respond with proper errors if uuid is not registered" do
        reg = FactoryGirl.create(:registration)
        dev = FactoryGirl.create(:pending_device, registration: reg)
        post "/api/v1/resend_otp", params: {
          dialing_prefix: reg.dialing_prefix,
          mobile_number: reg.mobile_number,
          uuid: "1072031b20312b3",
        }

        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)
        
        expect(response_body["success"]).to be(false)
        expect(response_body["alert"]).to be_blank

        expect(response_body["errors"]["heading"]).to  eq("The device is not registered")
        expect(response_body["errors"]["message"]).to  eq("Resending OTP Failed. Check if the UUID entered is valid")
        expect(response_body["errors"]["details"]["uuid"]).to  eq("is invalid")
      end

      it "should respond with proper errors if the device is blocked" do
        reg = FactoryGirl.create(:registration)
        dev = FactoryGirl.create(:blocked_device, registration: reg)
        post "/api/v1/resend_otp", params: {
                                          uuid: dev.uuid,
                                          dialing_prefix: reg.dialing_prefix, 
                                          mobile_number: reg.mobile_number
                                        }

        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to be(false)
        expect(response_body["alert"]).to be_blank

        expect(response_body["errors"]["heading"]).to  eq("This device is blocked")
        expect(response_body["errors"]["message"]).to  eq("You must have done some mal-practices")
      end
    end
  end

  describe "verify" do
    context "Positive Case" do
      it "should verify an otp verification request from a pending device" do
        reg = FactoryGirl.create(:pending_registration, user: nil)
        dev = FactoryGirl.create(:pending_device, registration: reg)

        # Generating a new OTP
        dev.generate_otp
        dev.reload

        post "/api/v1/verify_otp", params: {
                                          otp: dev.otp,
                                          uuid: dev.uuid,
                                          dialing_prefix: reg.dialing_prefix, 
                                          mobile_number: reg.mobile_number
                                        }

        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to be(true)
        expect(response_body["errors"]).to be_blank

        expect(response_body["alert"]["heading"]).to  eq("OTP was verified succesfully")
        expect(response_body["alert"]["message"]).to  eq("You may need to accept the terms and conditions to get the API token if you have not yet finised the registration")

        dev.reload
        data = response_body["data"]

        expect(data["api_token"]).to be_blank

        expect(data["registration"]["id"]).not_to be_blank
        expect(data["registration"]["country_id"]).to eq(reg.country.id)
        expect(data["registration"]["city_id"]).to eq(reg.city.id)
        expect(data["registration"]["dialing_prefix"]).to eq(reg.dialing_prefix)
        expect(data["registration"]["mobile_number"]).to eq(reg.mobile_number)
        expect(data["registration"]["user_id"]).to be_blank
        expect(data["registration"]["status"]).to match("verified")

        expect(data["profile"]["id"]).to be_blank
        expect(data["profile"]["name"]).to be_blank
        expect(data["profile"]["gender"]).to be_blank
        expect(data["profile"]["email"]).to be_blank
        expect(data["profile"]["date_of_birth"]).to be_blank
      end
      it "should verify the otp if the device is verified, tac is accpted and return the api token" do
        reg = FactoryGirl.create(:verified_registration)
        dev = FactoryGirl.create(:verified_device, registration: reg)

        # Generating a new OTP
        dev.generate_otp
        dev.update_attribute(:tac_accepted_at, Time.now)
        dev.reload

        post "/api/v1/verify_otp", params: {
                                          otp: dev.otp,
                                          uuid: dev.uuid,
                                          dialing_prefix: reg.dialing_prefix, 
                                          mobile_number: reg.mobile_number
                                        }

        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to be(true)
        expect(response_body["errors"]).to be_blank

        expect(response_body["alert"]["heading"]).to  eq("OTP was verified succesfully")
        expect(response_body["alert"]["message"]).to  eq("You may need to accept the terms and conditions to get the API token if you have not yet finised the registration")

        dev.reload
        data = response_body["data"]

        expect(data["api_token"]).to eq(dev.api_token)
        
        expect(data["registration"]["id"]).not_to be_blank
        expect(data["registration"]["country_id"]).to eq(reg.country.id)
        expect(data["registration"]["city_id"]).to eq(reg.city.id)
        expect(data["registration"]["dialing_prefix"]).to eq(reg.dialing_prefix)
        expect(data["registration"]["mobile_number"]).to eq(reg.mobile_number)
        expect(data["registration"]["user_id"]).not_to be_blank
        expect(data["registration"]["status"]).to match(reg.status)

        expect(data["profile"]["id"]).to eq(reg.user.id)
        expect(data["profile"]["name"]).to eq(reg.user.name)
        expect(data["profile"]["gender"]).to eq(reg.user.gender)
        expect(data["profile"]["email"]).to eq(reg.user.email)
        expect(data["profile"]["date_of_birth"]).to eq(reg.user.date_of_birth.to_s)
      end
    end
    context "Negative Case" do
      it "should respond with proper errors if no parameters are passed" do
        
        reg = FactoryGirl.create(:pending_registration)
        dev = FactoryGirl.create(:pending_device, registration: reg)
        
        # Generating a new OTP
        dev.generate_otp
        dev.reload

        post "/api/v1/verify_otp", params: {}

        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to be(false)
        expect(response_body["alert"]).to be_blank

        expect(response_body["errors"]["heading"]).to  eq("The mobile number is not registered")
        expect(response_body["errors"]["message"]).to  eq("Verifying OTP Failed. Check if the mobile number entered is valid")
        expect(response_body["errors"]["details"]["mobile_number"]).to  eq("is invalid")
      end

      it "should respond with proper errors if mobile number is not registered" do
        reg = FactoryGirl.create(:pending_registration)
        dev = FactoryGirl.create(:pending_device, registration: reg)

        # Generating a new OTP
        dev.generate_otp
        dev.reload

        post "/api/v1/verify_otp", params: {
                                          otp: dev.otp,
                                          dialing_prefix: "+91", 
                                          mobile_number: "1234512345"
                                        }

        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to be(false)
        expect(response_body["alert"]).to be_blank

        expect(response_body["errors"]["heading"]).to  eq("The mobile number is not registered")
        expect(response_body["errors"]["message"]).to  eq("Verifying OTP Failed. Check if the mobile number entered is valid")
        expect(response_body["errors"]["details"]["mobile_number"]).to  eq("is invalid")
      end

      it "should respond with proper errors if uuid is not registered" do
        reg = FactoryGirl.create(:verified_registration)
        dev = FactoryGirl.create(:pending_device, registration: reg)

        # Generating a new OTP
        dev.generate_otp
        dev.reload

        post "/api/v1/verify_otp", params: {
                                          otp: "11111",
                                          dialing_prefix: reg.dialing_prefix, 
                                          mobile_number: reg.mobile_number,
                                          uuid: "1072031b20312b3"
                                        }

        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)
        
        expect(response_body["success"]).to be(false)
        expect(response_body["alert"]).to be_blank

        expect(response_body["errors"]["heading"]).to  eq("The device is not registered")
        expect(response_body["errors"]["message"]).to  eq("Verifying OTP Failed. Check if the UUID entered is valid")
        expect(response_body["errors"]["details"]["uuid"]).to  eq("is invalid")
      end

      it "should respond with proper errors if the device is blocked" do
        reg = FactoryGirl.create(:registration)
        dev = FactoryGirl.create(:blocked_device, registration: reg)
        post "/api/v1/verify_otp", params: {
                                          otp: dev.otp,
                                          dialing_prefix: reg.dialing_prefix, 
                                          mobile_number: reg.mobile_number,
                                          uuid: dev.uuid
                                        }

        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)
        
        expect(response_body["success"]).to be(false)
        expect(response_body["alert"]).to be_blank

        expect(response_body["errors"]["heading"]).to  eq("This device is blocked")
        expect(response_body["errors"]["message"]).to  eq("You must have done some mal-practices")
      end
    end
  end

  describe "accept_tac" do
    context "Positive Case" do
      it "should accept the terms and conditions if the device is verified and all inputs are valid" do
        
        reg = FactoryGirl.create(:verified_registration)
        dev = FactoryGirl.create(:verified_device, registration: reg)
        
        post "/api/v1/accept_tac", params: {
                                          terms_and_conditions: true,
                                          uuid: dev.uuid,
                                          dialing_prefix: reg.dialing_prefix, 
                                          mobile_number: reg.mobile_number
                                        }

        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)
        
        expect(response_body["success"]).to be(true)
        expect(response_body["errors"]).to be_blank

        expect(response_body["alert"]["heading"]).to  eq("You have successfully accepted the Terms & Conditions. Proceed with Registration process if any")
        expect(response_body["alert"]["message"]).to  eq("Store and use the API token for further communication")

        dev.reload
        expect(response_body["data"]["api_token"]).to eq(dev.api_token)
      end
    end
    context "Negative Case" do
      it "should not accept the terms and conditions if the device is not verified" do
        reg = FactoryGirl.create(:pending_registration)
        dev = FactoryGirl.create(:pending_device, registration: reg)
        
        post "/api/v1/accept_tac", params: {
                                          terms_and_conditions: true,
                                          uuid: dev.uuid,
                                          dialing_prefix: reg.dialing_prefix, 
                                          mobile_number: reg.mobile_number
                                        }

        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)
        
        expect(response_body["success"]).to be(false)
        expect(response_body["alert"]).to be_blank
        expect(response_body["data"]).to be_blank

        expect(response_body["errors"]["heading"]).to  eq("This device is not verified")
        expect(response_body["errors"]["message"]).to  eq("You need to verify this device before you can accept the terms and conditions")
      end

      it "should respond with proper errors if no params are passed" do
        reg = FactoryGirl.create(:verified_registration)
        dev = FactoryGirl.create(:verified_device, registration: reg)
        
        post "/api/v1/accept_tac", params: {}

        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)
        
        expect(response_body["success"]).to be(false)
        expect(response_body["alert"]).to be_blank
        expect(response_body["data"]).to be_blank

        expect(response_body["errors"]["heading"]).to  eq("The mobile number is not registered")
        expect(response_body["errors"]["message"]).to  eq("Verifying OTP Failed. Check if the mobile number entered is valid")
        expect(response_body["errors"]["details"]["mobile_number"]).to eq("is invalid")
      end

      it "should respond with proper errors if T&C is not accepted" do
        reg = FactoryGirl.create(:verified_registration)
        dev = FactoryGirl.create(:verified_device, registration: reg)
        post "/api/v1/accept_tac", params: {
                                          terms_and_conditions: false,
                                          uuid: dev.uuid,
                                          dialing_prefix: reg.dialing_prefix, 
                                          mobile_number: reg.mobile_number
                                        }

        expect(response.status).to eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to be(false)
        expect(response_body["alert"]).to be_blank
        expect(response_body["data"]).to be_blank

        expect(response_body["errors"]["heading"]).to  eq("You have not accepted the Terms & Conditions. Registration is complete only if you accept the T&C")
        expect(response_body["errors"]["message"]).to  eq("Accept the T&C to finish the Registration. Pass true")
        expect(response_body["errors"]["details"]["terms_and_conditions"]).to  eq("must be true")
      end
    end
  end

end