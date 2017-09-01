module Usman
  module ApiHelper
    def current_user
      # Return if @current_user is already initialized else check if the user exists with the auth token present in request header
      @current_user ||= authenticate_with_http_token { |token, options| User.find_by(auth_token: token)}
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
  end
end