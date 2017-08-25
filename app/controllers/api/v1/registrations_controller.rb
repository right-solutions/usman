module Api
  module V1
    class RegistrationsController < ActionController::API

      include Usman::ApiHelper

      def register
        proc_code = Proc.new do
          @reg_data = Usman::MobileRegistrationService.new(params)
          @errors = @reg_data.errors
          @success = false
          if @errors[:heading].blank?
            @success = true
            @alert = {
              heading: I18n.translate("mobile_registration.otp_sent.heading"),
              message: I18n.translate("mobile_registration.otp_sent.message")
            }
            @data = {
                      registration: @reg_data.registration,
                      device: @reg_data.device
                    }
          end
        end
        render_json_response(proc_code)
      end

      def resend_otp
        proc_code = Proc.new do

        end
        render_json_response(proc_code)
      end

      def verify
        proc_code = Proc.new do
          @device = Device.where("uuid = ?", params[:uuid]).first
          if @device
            if @device.blocked?
              @success = false
              @errors = {
                heading: I18n.translate("mobile_registration.device_blocked.heading"),
                message: I18n.translate("mobile_registration.device_blocked.message"),
                details: {}
              }
            else
              valid, validation_errors = @device.validate_otp(params[:otp], params[:dialing_prefix], params[:mobile_number])
              if valid
                @success = true
                @alert = {
                  heading: I18n.translate("mobile_registration.verification_success.heading"),
                  message: I18n.translate("mobile_registration.verification_success.message")
                }
                @data = { api_token: @device.api_token }
              else
                @success = false
                @errors = {
                  heading: I18n.translate("mobile_registration.otp_not_matching.heading"),
                  message: I18n.translate("mobile_registration.otp_not_matching.message"),
                  details: validation_errors
                }
              end
            end
          else
            @success = false
            @errors = {
              heading: I18n.translate("general.unexpected_failure.heading"),
              message: I18n.translate("general.unexpected_failure.message"),
              details: {
                uuid: "is invalid"
              }
            }
          end
        end
        render_json_response(proc_code)
      end
    end
  end
end

