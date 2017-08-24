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
        end
        render_json_response(proc_code)
      end
    end
  end
end

