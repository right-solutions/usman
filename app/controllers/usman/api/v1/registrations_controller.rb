module Usman
  module Api
    module V1
      class RegistrationsController < Usman::Api::V1::BaseController

        skip_before_action :require_api_token, except: [:send_otp_to_change_number, :change_number, :delete_account]

        def register
          proc_code = Proc.new do
            @reg_data = Usman::MobileRegistrationService.new(params)
            @errors = @reg_data.errors
            @success = false
            if @errors[:heading].blank?
              @success = true
              @alert = {
                heading: I18n.translate("api.register.otp_sent.heading"),
                message: I18n.translate("api.register.otp_sent.message")
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
            @registration = Registration.where("mobile_number = ? AND dialing_prefix = ?", params[:mobile_number], params[:dialing_prefix]).first
            if @registration
              @device = @registration.devices.where("uuid = ?", params[:uuid]).first
              if @device
                if @device.blocked?
                  @success = false
                  @errors = {
                    heading: I18n.translate("api.general.device_blocked.heading"),
                    message: I18n.translate("api.general.device_blocked.message"),
                    details: {}
                  }
                else
                  valid, validation_errors = @device.resend_otp(params[:dialing_prefix], params[:mobile_number])
                  if valid
                    @success = true
                    @alert = {
                      heading: I18n.translate("api.resend_otp.new_otp_sent.heading"),
                      message: I18n.translate("api.resend_otp.new_otp_sent.message")
                    }
                    @data = {}
                  else
                    @success = false
                    @errors = {
                      heading: I18n.translate("api.resend_otp.otp_not_matching.heading"),
                      message: I18n.translate("api.resend_otp.otp_not_matching.message"),
                      details: validation_errors
                    }
                  end
                end
              else
                @success = false
                @errors = {
                  heading: I18n.translate("api.general.device_not_registered.heading"),
                  message: I18n.translate("api.general.device_not_registered.message"),
                  details: {
                    uuid: "is invalid"
                  }
                }
              end
            else
              @success = false
              @errors = {
                heading: I18n.translate("api.general.mobile_number_not_registered.heading"),
                message: I18n.translate("api.general.mobile_number_not_registered.message"),
                details: {
                  mobile_number: "is invalid"
                }
              }
            end
          end
          render_json_response(proc_code)
        end

        def verify_otp
          proc_code = Proc.new do
            @registration = Registration.where("mobile_number = ? AND dialing_prefix = ?", params[:mobile_number], params[:dialing_prefix]).first
            if @registration
              @device = @registration.devices.where("uuid = ?", params[:uuid]).first
              if @device
                if @device.blocked?
                  @success = false
                  @errors = {
                    heading: I18n.translate("api.general.device_blocked.heading"),
                    message: I18n.translate("api.general.device_blocked.message"),
                    details: {}
                  }
                else
                  valid, validation_errors = @device.validate_otp(params[:otp], params[:dialing_prefix], params[:mobile_number])
                  if valid
                    @success = true
                    @alert = {
                      heading: I18n.translate("api.verify_otp.verification_success.heading"),
                      message: I18n.translate("api.verify_otp.verification_success.message")
                    }
                    if @device.verified? && @device.tac_accepted?
                      @data = { api_token: @device.api_token }
                    else
                      @data = { api_token: "" } 
                    end
                    @data[:registration] = ActiveModelSerializers::SerializableResource.new(@registration, serializer: RegistrationSerializer)
                    @data[:profile] = ActiveModelSerializers::SerializableResource.new(@registration.user, serializer: ProfileSerializer)
                  else
                    @success = false
                    @errors = {
                      heading: I18n.translate("api.verify_otp.otp_not_matching.heading"),
                      message: I18n.translate("api.verify_otp.otp_not_matching.message"),
                      details: validation_errors
                    }
                  end
                end
              else
                @success = false
                @errors = {
                  heading: I18n.translate("api.general.device_not_registered.heading"),
                  message: I18n.translate("api.general.device_not_registered.message"),
                  details: {
                    uuid: "is invalid"
                  }
                }
              end
            else
              @success = false
              @errors = {
                heading: I18n.translate("api.general.mobile_number_not_registered.heading"),
                message: I18n.translate("api.general.mobile_number_not_registered.message"),
                details: {
                  mobile_number: "is invalid"
                }
              }
            end
          end
          render_json_response(proc_code)
        end

        def accept_tac
          proc_code = Proc.new do
            @registration = Registration.where("mobile_number = ? AND dialing_prefix = ?", params[:mobile_number], params[:dialing_prefix]).first
            if @registration
              @device = @registration.devices.where("uuid = ?", params[:uuid]).first
              if @device
                if @device.blocked?
                  @success = false
                  @errors = {
                    heading: I18n.translate("api.general.device_blocked.heading"),
                    message: I18n.translate("api.general.device_blocked.message"),
                    details: {}
                  }
                elsif @device.pending?
                  @success = false
                  @errors = {
                    heading: I18n.translate("api.accept_tac.device_pending.heading"),
                    message: I18n.translate("api.accept_tac.device_pending.message"),
                    details: {}
                  }
                else
                  valid, validation_errors = @device.accept_tac(params[:terms_and_conditions], params[:dialing_prefix], params[:mobile_number])
                  if valid
                    @success = true
                    @alert = {
                      heading: I18n.translate("api.accept_tac.tac_accepted.heading"),
                      message: I18n.translate("api.accept_tac.tac_accepted.message")
                    }
                    if @device.verified? && @device.tac_accepted?
                      @data = { api_token: @device.api_token } 
                      @data[:registration] = ActiveModelSerializers::SerializableResource.new(@registration, serializer: RegistrationSerializer)
                      @data[:profile] = ActiveModelSerializers::SerializableResource.new(@registration.user, serializer: ProfileSerializer)
                    end
                  else
                    @success = false
                    @errors = {
                      heading: I18n.translate("api.accept_tac.tac_not_accepted.heading"),
                      message: I18n.translate("api.accept_tac.tac_not_accepted.message"),
                      details: validation_errors
                    }
                  end
                end
              else
                @success = false
                @errors = {
                  heading: I18n.translate("api.general.device_not_registered.heading"),
                  message: I18n.translate("api.general.device_not_registered.message"),
                  details: {
                    uuid: "is invalid"
                  }
                }
              end
            else
              @success = false
              @errors = {
                heading: I18n.translate("api.general.mobile_number_not_registered.heading"),
                message: I18n.translate("api.general.mobile_number_not_registered.message"),
                details: {
                  mobile_number: "is invalid"
                }
              }
            end
          end
          render_json_response(proc_code)
        end

        def send_otp_to_change_number
          proc_code = Proc.new do
            if @current_registration
              unless @current_user
                @success = false
                @errors = {
                  heading: I18n.translate("api.profile.user_does_not_exists.heading"),
                  message: I18n.translate("api.profile.user_does_not_exists.message")
                }
              else
                @device = @current_registration.devices.where("uuid = ?", params[:uuid]).first
                
                if @device
                  if @device.blocked?
                    @success = false
                    @errors = {
                      heading: I18n.translate("api.general.device_blocked.heading"),
                      message: I18n.translate("api.general.device_blocked.message"),
                      details: {}
                    }
                  else
                    @device.send_otp
                    @success = true
                    @alert = {
                      heading: I18n.translate("api.send_otp_to_change_number.otp_send.heading"),
                      message: I18n.translate("api.send_otp_to_change_number.otp_send.message")
                    }
                  end
                else
                  @success = false
                  @errors = {
                    heading: I18n.translate("api.general.device_not_registered.heading"),
                    message: I18n.translate("api.general.device_not_registered.message"),
                  }
                end
              end
            else
              @success = false
              @errors = {
                heading: I18n.translate("api.profile.registration_details_missing.heading"),
                message: I18n.translate("api.profile.registration_details_missing.message")
              }
            end
          end
          render_json_response(proc_code)
        end

        def change_number
          proc_code = Proc.new do
            if @current_registration
              unless @current_user
                @success = false
                @errors = {
                  heading: I18n.translate("api.profile.user_does_not_exists.heading"),
                  message: I18n.translate("api.profile.user_does_not_exists.message")
                }
              else
                @device = @current_registration.devices.where("uuid = ?", params[:uuid]).first
                
                if @device
                  if @device.blocked?
                    @success = false
                    @errors = {
                      heading: I18n.translate("api.general.device_blocked.heading"),
                      message: I18n.translate("api.general.device_blocked.message"),
                      details: {}
                    }
                  else
                    valid, validation_errors = @device.change_number(params[:otp], params[:old_dialing_prefix], params[:old_mobile_number], params[:new_dialing_prefix], params[:new_mobile_number])
                    if valid
                      @success = true
                      @alert = {
                        heading: I18n.translate("api.change_number.number_changed.heading"),
                        message: I18n.translate("api.change_number.number_changed.message")
                      }
                    else
                      @success = false
                      @errors = {
                        heading: I18n.translate("api.change_number.number_change_failed.heading"),
                        message: I18n.translate("api.change_number.number_change_failed.message"),
                        details: validation_errors
                      }
                    end
                    
                  end
                else
                  @success = false
                  @errors = {
                    heading: I18n.translate("api.general.device_not_registered.heading"),
                    message: I18n.translate("api.general.device_not_registered.message"),
                  }
                end
              end
            else
              @success = false
              @errors = {
                heading: I18n.translate("api.profile.registration_details_missing.heading"),
                message: I18n.translate("api.profile.registration_details_missing.message")
              }
            end
          end
          render_json_response(proc_code)
        end

        def delete_account
          proc_code = Proc.new do
            if @current_registration
              unless @current_user
                @success = false
                @errors = {
                  heading: I18n.translate("api.profile.user_does_not_exists.heading"),
                  message: I18n.translate("api.profile.user_does_not_exists.message")
                }
              else
                if @current_registration.delete!
                  @success = true
                  @alert = {
                    heading: I18n.translate("api.delete_account.account_deleted.heading"),
                    message: I18n.translate("api.delete_account.account_deleted.message")
                  }
                else
                  @success = false
                  @errors = {
                    heading: I18n.translate("api.delete_account.account_deletion_failed.heading"),
                    message: I18n.translate("api.delete_account.account_deletion_failed.message"),
                    details: validation_errors
                  }
                end
              end
            else
              @success = false
              @errors = {
                heading: I18n.translate("api.profile.registration_details_missing.heading"),
                message: I18n.translate("api.profile.registration_details_missing.message")
              }
            end
          end
          render_json_response(proc_code)
        end

      end
    end
  end
end

