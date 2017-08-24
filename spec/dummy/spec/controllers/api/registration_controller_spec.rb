require "rails_helper"

RSpec.describe Api::V1::RegistrationsController, :type => :request do  

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
      
        expect(response.status).to  eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to  eq(true)
        
        expect(response_body["alert"]["heading"]).to  eq("An OTP has been sent to you")
        expect(response_body["alert"]["message"]).to  eq("Check your mobile for new message from us.")

        data = response_body['data']

        expect(data["registration"]["id"]).not_to  be_blank
        expect(data["registration"]["country_id"]).to  eq(country.id)
        expect(data["registration"]["city_id"]).to  eq(city.id)
        expect(data["registration"]["dialing_prefix"]).to  eq("+971")
        expect(data["registration"]["mobile_number"]).to  eq("554455339")
        expect(data["registration"]["user_id"]).to  be_blank

        expect(data["device"]["user_id"]).to  be_blank
        expect(data["device"]["registration_id"]).not_to  be_blank
        expect(data["device"]["uuid"]).to match(uuid)
        expect(data["device"]["device_token"]).to  match(device_token)
        expect(data["device"]["device_name"]).to  match("Apple iPhone")
        expect(data["device"]["device_type"]).to  match("iPhone 7 Plus")
        expect(data["device"]["operating_system"]).to  match("iPhone 7 Plus")
        expect(data["device"]["software_version"]).to  match("Apple iOS")
      end

      it "should register and reuse an existing device information" do
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
      
        expect(response.status).to  eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to  eq(true)

        expect(response_body["alert"]["heading"]).to  eq("An OTP has been sent to you")
        expect(response_body["alert"]["message"]).to  eq("Check your mobile for new message from us.")

        data = response_body['data']
        
        expect(data["registration"]["id"]).to  be(reg.id)
        expect(data["registration"]["country_id"]).to  eq(reg.country.id)
        expect(data["registration"]["city_id"]).to  eq(reg.city.id)
        expect(data["registration"]["dialing_prefix"]).to  eq(reg.dialing_prefix)
        expect(data["registration"]["mobile_number"]).to  eq(reg.mobile_number)
        expect(data["registration"]["user_id"]).to  eq(reg.user.id)
        
        expect(data["device"]["registration_id"]).to  be(reg.id)
        expect(data["device"]["uuid"]).to match(uuid)
        expect(data["device"]["device_token"]).to  match(device_token)
        expect(data["device"]["device_name"]).to  match("Apple iPhone")
        expect(data["device"]["device_type"]).to  match("iPhone 7 Plus")
        expect(data["device"]["operating_system"]).to  match("iPhone 7 Plus")
        expect(data["device"]["software_version"]).to  match("Apple iOS")
        expect(data["device"]["user_id"]).to  be(reg.user.id)
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
      
        expect(response.status).to  eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to  eq(true)

        expect(response_body["alert"]["heading"]).to  eq("An OTP has been sent to you")
        expect(response_body["alert"]["message"]).to  eq("Check your mobile for new message from us.")

        data = response_body['data']
        
        expect(data["registration"]["id"]).to  be(reg.id)
        expect(data["registration"]["country_id"]).to  eq(reg.country.id)
        expect(data["registration"]["city_id"]).to  eq(reg.city.id)
        expect(data["registration"]["dialing_prefix"]).to  eq(reg.dialing_prefix)
        expect(data["registration"]["mobile_number"]).to  eq(reg.mobile_number)
        expect(data["registration"]["user_id"]).to  eq(reg.user.id)
        
        expect(data["device"]["registration_id"]).to  be(reg.id)
        expect(data["device"]["uuid"]).to match(dev.uuid)
        expect(data["device"]["device_token"]).to  match(dev.device_token)
        expect(data["device"]["device_name"]).to  match(dev.device_name)
        expect(data["device"]["device_type"]).to  match(dev.device_type)
        expect(data["device"]["operating_system"]).to  match(dev.operating_system)
        expect(data["device"]["software_version"]).to  match(dev.software_version)
        expect(data["device"]["user_id"]).to  be(dev.user.id)
      end
    end
    context 'Negative Cases' do
      it "should set proper errors if no input is given" do
        post "/api/v1/register", params: {}
      
        expect(response.status).to  eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to  eq(false)
        expect(response_body["data"]).to  be_blank
        expect(response_body["alert"]).to  be_blank

        expect(response_body["errors"]["heading"]).to eq("Registring new mobile number FAILED.")
        expect(response_body["errors"]["message"]).to eq("Check if all mandatory details are passed. Refer the error details for technical information.")
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
      
        expect(response.status).to  eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to  eq(false)
        expect(response_body["data"]).to  be_blank
        expect(response_body["alert"]).to  be_blank

        expect(response_body["errors"]["heading"]).to eq("Registring new mobile number FAILED.")
        expect(response_body["errors"]["message"]).to eq("Check if all mandatory details are passed. Refer the error details for technical information.")
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
      
        expect(response.status).to  eq(200)

        response_body = JSON.parse(response.body)

        expect(response_body["success"]).to  eq(false)
        expect(response_body["data"]).to  be_blank
        expect(response_body["alert"]).to  be_blank

        expect(response_body["errors"]["heading"]).to eq("Registring new mobile number FAILED.")
        expect(response_body["errors"]["message"]).to eq("Check if all mandatory details are passed. Refer the error details for technical information.")
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
      
        expect(response.status).to  eq(200)

        response_body = JSON.parse(response.body)
        
        expect(response_body["success"]).to  eq(false)
        expect(response_body["data"]).to  be_blank
        expect(response_body["alert"]).to  be_blank

        expect(response_body["errors"]["heading"]).to eq("This device is blocked.")
        expect(response_body["errors"]["message"]).to eq("You must have done some mal-practices.")
        expect(response_body["errors"]["details"]).to be_empty
      end
    end
  end

  # describe "resend_otp" do
  #   context "Positive Case" do
  #     it "should resend the otp for valid inputs" do
  #       resend_input = {
  #                 dialing_prefix: "+971", 
  #                 mobile_number: "554455339",
  #                 uuid: uuid
  #               }

  #       post "/api/v1/resend_otp", params: resend_input
      
  #       expect(response.status).to  eq(200)

  #       response_body = JSON.parse(response.body)

  #       expect(response_body["success"]).to  eq(true)
  #       expect(response_body["data"]).to  be_blank

  #       data = response_body['data']

  #       expect(data["registration"]["id"]).not_to  be_blank
  #       expect(data["registration"]["country_id"]).to  eq(country.id)
  #       expect(data["registration"]["city_id"]).to  eq(city.id)
  #       expect(data["registration"]["dialing_prefix"]).to  eq("+971")
  #       expect(data["registration"]["mobile_number"]).to  eq("554455339")
  #       expect(data["registration"]["user_id"]).to  be_blank

  #       expect(data["device"]["user_id"]).to  be_blank
  #       expect(data["device"]["registration_id"]).not_to  be_blank
  #       expect(data["device"]["uuid"]).to match(uuid)
  #       expect(data["device"]["device_token"]).to  match(device_token)
  #       expect(data["device"]["device_name"]).to  match("Apple iPhone")
  #       expect(data["device"]["device_type"]).to  match("iPhone 7 Plus")
  #       expect(data["device"]["operating_system"]).to  match("iPhone 7 Plus")
  #       expect(data["device"]["software_version"]).to  match("Apple iOS")
  #     end
  #   end
  #   context "Negative Case" do
  #   end
  # end

end