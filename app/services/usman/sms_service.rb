require 'aws-sdk-sns'
require 'yaml'

module Usman
  class SmsService

    attr_reader :dialing_prefix, :mobile_number, :message,
                :error_heading, :error_message, :error_details,
                :aws_credentials, :sns_client
                

    def initialize(params)
      @dialing_prefix = params[:dialing_prefix]
      @mobile_number = params[:mobile_number]
      @message = params[:message]
      @aws_credentials = {}

      # Initialize error variables
      clear_errors
    end

    def get_config_file
      'config/aws-secret.yml'
    end

    def get_aws_credentials
      if File.exist?(get_config_file)
        @aws_credentials = YAML.load_file(get_config_file)
        unless @aws_credentials.is_a?(Hash) && 
               @aws_credentials.has_key?("region") &&
               @aws_credentials.has_key?("access_key_id") &&
               @aws_credentials.has_key?("secret_access_key")
          set_error("sms.credentials.invalid_format", errors)
          return
        end
        begin
          create_sns_client
        rescue Aws::SNS::Errors::ServiceError
          set_error("sms.credentials.invalid_credentials", errors)
          return
        rescue
          set_error("sms.credentials.unexpected_error", errors)
          return
        end
      else
        set_error("sms.credentials.secret_file_not_found", errors)
        return
      end
      @aws_credentials
    end

    def create_sns_client
      @sns_client = Aws::SNS::Client.new(
        region: @aws_credentials["region"],
        access_key_id: @aws_credentials["access_key_id"],
        secret_access_key: @aws_credentials["secret_access_key"]
      )
    end

    def send_sms
      # Get AWS Credentials to create an SNS Client
      get_aws_credentials

      if @error_heading.blank?
        phone_number = "#{@dialing_prefix}#{@mobile_number}"
        @sns_client.publish(phone_number: phone_number, message: @message)
      end
    end

    def set_error(key, hsh={})
      @error_heading = I18n.t("#{key}.heading")
      @error_message = I18n.t("#{key}.message")
      @error_details = hsh if hsh.is_a?(Hash)
    end

    def clear_errors
      @error_heading = nil
      @error_message = nil
      @error_details = {}
    end

    def errors
      {
        heading: @error_heading,
        message: @error_message,
        details: @error_details
      }
    end

  end
end