module Usman
  module ApiHelper
    def current_user
      # Return if @current_user is already initialized else check if the user exists with the auth token present in request header
      @current_user ||= authenticate_with_http_token { |token, options| User.find_by(auth_token: token)}
    end

    def current_device
      # Return if @current_device is already initialized else check if the device exists with the api token present in request header
      @current_device ||= authenticate_with_http_token { |token, options| Device.find_by(api_token: token)}
      @current_registration = @current_device.registration if @current_device
      @current_user = @current_registration.user if @current_registration
    end

    def require_auth_token
      current_user
      unless @current_user
        proc_code = Proc.new do
          set_notification_messages("authentication.permission_denied", :error)
          raise AuthenticationError
        end
        render_json_response(proc_code)
        return
      end
    end

    def require_api_token
      current_device
      unless @current_device
        proc_code = Proc.new do
          @success = false
          @errors = {
            heading: I18n.translate("api.general.permission_denied.heading"),
            message: I18n.translate("api.general.permission_denied.message")
          }
        end
        render_json_response(proc_code)
        return
      else
        @current_user = @current_device.try(:registration).try(:user)
      end
      if @current_user
        if @current_user.pending?
          proc_code = Proc.new do
            @success = false
            @errors = {
              heading: I18n.translate("api.authentication.user_is_pending.heading"),
              message: I18n.translate("api.authentication.user_is_pending.message")
            }
          end
          render_json_response(proc_code)
          return
        elsif @current_user.suspended?
          proc_code = Proc.new do
            @success = false
            @errors = {
              heading: I18n.translate("api.authentication.user_is_suspended.heading"),
              message: I18n.translate("api.authentication.user_is_suspended.message")
            }
          end
          render_json_response(proc_code)
          return
        end
      end
    end

    def require_super_admin_auth_token
      current_user
      unless @current_user && @current_user.is_super_admin?
        proc_code = Proc.new do
          set_notification_messages("authentication.permission_denied", :error)
          raise AuthenticationError
        end
        render_json_response(proc_code)
        return
      end
    end

    def require_admin_auth_token
      current_user
      unless @current_user && @current_user.is_admin?
        proc_code = Proc.new do
          set_notification_messages("authentication.permission_denied", :error)
          raise AuthenticationError
        end
        render_json_response(proc_code)
        return
      end
    end

    def store_last_accessed_api
      if @current_device
        # Know what was the last API accessed and when
        # This is to catch the users who are inactive
        @current_device.last_accessed_api = request.original_url
        @current_device.last_accessed_at = Time.now
        @current_device.save
      end
    end

  end
end