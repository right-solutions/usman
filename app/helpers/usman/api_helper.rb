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

    def embed_stack_in_json_response?
      return true if Rails.env.development?
      Rails.env.production? && ["true", "t", "1", "yes"].include?(params[:debug].to_s.downcase.strip)
    end

    ## This method will accept a proc, execute it and render the json
    def render_json_response(proc_code)

      begin
        proc_code.call
        @success = @success == false ? (false) : (true)
      rescue Exception => e
        @success = false
        @errors = { 
                    heading: I18n.translate("general.unexpected_failure.heading"),
                    message: I18n.translate("general.unexpected_failure.message"),
                    details: e.message,
                    stacktrace: (embed_stack_in_json_response? ? e.backtrace : nil)
                  }
      end
      @status ||= 200

      response_hash = {success: @success}
      response_hash[:alert] = @alert unless @alert.blank?
      response_hash[:data] = @data unless @data.blank?
      response_hash[:errors] = @errors unless @errors.blank?
      
      response_hash[:total_data] = @total_data unless @total_data.blank?
      response_hash[:per_page] = @per_page unless @per_page.blank?
      response_hash[:current_page] = @current_page unless @current_page.blank?

      render status: @status, json: response_hash
      return
    end
  end
end