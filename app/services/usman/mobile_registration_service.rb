module Usman
  class MobileRegistrationService

    attr_reader :dialing_prefix, :mobile_number, 
                :country, :city, 
                :error_heading, :error_message, :error_details, 
                :uuid, :device_token,
                :device_name, :device_type,
                :operating_system, :software_version,
                :registration, :device, :remote_ip

    def initialize(params)
      @dialing_prefix = params[:dialing_prefix]
      @mobile_number = params[:mobile_number]
      
      @country = nil
      @city = nil
      @country = Country.find_by_id(params[:country_id])
      @city = City.find_by_id(params[:city_id])

      # Edge case to catch city selected that of a different country
      @city = nil unless @city.country == @country if @city
      
      @uuid = params[:uuid]
      @device_token = params[:device_token]
      @device_name = params[:device_name]
      @device_type = params[:device_type]
      @operating_system = params[:operating_system]
      @software_version = params[:software_version]

      @remote_ip = params[:remote_ip]
      @error_message = nil
      @error_details = {}

      # @registration and @device will be initiated by the
      # below method if the device is already registered
      check_if_device_is_already_registered

      register_new_device

      # Validate the inputs
      @registration.valid?
      @device.valid?

      if @registration.errors.any? or @device.errors.any?
        errors = @registration.errors.to_hash.merge(@device.errors.to_hash)
        set_error("api.mobile_registration.invalid_inputs", errors)
      end
    end

    def check_if_device_is_already_registered
      @registration = Registration.where("LOWER(mobile_number) = LOWER('#{@mobile_number}')").first
      if @registration
        @registration.country = @country
        @registration.city = @city
      end
      @device = Device.where("LOWER(uuid) = LOWER('#{@uuid}')").first if @registration
    end

    def register_new_device
      
      if @device && @device.blocked?
        set_error("api.mobile_registration.device_blocked")
        return
      end

      ActiveRecord::Base.transaction do
        # Create a new registration if it doesn't exist
        @registration = Registration.new unless @registration
        @registration.country = @country
        @registration.city = @city
        @registration.dialing_prefix = @dialing_prefix
        @registration.mobile_number = @mobile_number
        
        # Create device entry if it doesn't exist
        @device = Device.new unless @device
        @device.registration = @registration
        @device.user = @registration.user
        @device.uuid = @uuid
        @device.api_token = SecureRandom.hex
        @device.device_token = @device_token
        @device.device_name = @device_name
        @device.device_type = @device_type
        @device.operating_system = @operating_system
        @device.software_version = @software_version

        @registration.valid?
        @device.valid?

        if @registration.errors.blank? && @device.errors.blank?
          @registration.save
          @device.save
          generate_new_otp
        else
          raise ActiveRecord::Rollback 
        end
      end
    end

    def generate_new_otp
      @device.generate_otp
      if @device.send_otp
        @device.update_attribute(:otp_sent_at, Time.now)
      else
        set_error("api.mobile_registration.otp_not_sent")
      end
    end

    def set_error(key, hsh={})
      @error_heading = I18n.t("#{key}.heading")
      @error_message = I18n.t("#{key}.message")
      @error_details = hsh if hsh.is_a?(Hash)
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