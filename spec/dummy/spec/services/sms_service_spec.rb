require 'rails_helper'

describe Usman::SmsService do

  # Existing Registration with device details
  let(:sms_params) {
                     {  
                        dialing_prefix: "+971",
                        mobile_number: "544455339",
                        message: "This is a sample text SMS"
                      } 
                    }

  describe 'initialize' do

    context 'Positive Cases' do
      it "should send an SMS to mobile number provided" do
        ss = Usman::SmsService.new(sms_params)
        
        ss.stub(:get_config_file) { 'spec/dummy/config/aws-secret.yml' }
        ss.get_aws_credentials

        expect(ss.dialing_prefix).to eq("+971")
        expect(ss.mobile_number).to eq("544455339")
        expect(ss.message).to eq("This is a sample text SMS")
        
        expect(ss.error_heading).to be_nil
        expect(ss.error_message).to be_nil
        expect(ss.error_details).to be_empty
      end
    end

    context 'Negative Cases' do
      it "should return with proper errors if config file not found" do
        ss = Usman::SmsService.new(sms_params)
        
        ss.stub(:get_config_file) { 'spec/dummy/config/invalid.yml' }
        ss.get_aws_credentials
        
        expect(ss.dialing_prefix).to eq("+971")
        expect(ss.mobile_number).to eq("544455339")
        expect(ss.message).to eq("This is a sample text SMS")

        expect(ss.error_heading).to eq("AWS Secret File missing")
        expect(ss.error_message).to eq("Create the AWS Secret file in YAML format and put the credentials")
      end

      it "should return with proper errors if config file was not parsed" do
        ss = Usman::SmsService.new(sms_params)
        
        ss.stub(:get_config_file) { 'spec/dummy/config/invalid-aws-secret.yml' }
        ss.get_aws_credentials

        expect(ss.dialing_prefix).to eq("+971")
        expect(ss.mobile_number).to eq("544455339")
        expect(ss.message).to eq("This is a sample text SMS")

        expect(ss.error_heading).to eq("AWS Secret File is not in the required format")
        expect(ss.error_message).to eq("Region, AccessKeyId & SecretAccessKey shoudl have values")
      end
    end

  end
end