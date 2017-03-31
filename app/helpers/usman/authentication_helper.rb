module Usman
  module AuthenticationHelper

    private
    
    def current_user
      # Return if @current_user is already initialized else check if the user exists with the auth token present in request header
      @current_user ||= authenticate_with_http_token { |token, options| User.find_by(auth_token: token)}
    end
    
    # Returns the default URL to which the system should redirect the user after successful authentication
    def default_redirect_url_after_sign_in
      usman.admin_dashboard_url    
    end

    # Returns the default URL to which the system should redirect the user after an unsuccessful attempt to authorise a resource/page
    def default_sign_in_url
      usman.sign_in_url
    end

    # Method to handle the redirection after unsuccesful authentication
    # This method should also handle the redirection if it has come through a client appliction for authentication
    # In that case, it should persist the params passed by the client application
    def redirect_after_unsuccessful_authentication
      params_hsh = {}
      params_hsh[:client_app] = params[:client_app] if params[:client_app]
      params_hsh[:redirect_back_url] = params[:redirect_back_url] if params[:redirect_back_url]
      params_hsh[:requested_url] = request.original_url if request.get?
      redirect_to add_query_params(default_sign_in_url, params_hsh)
      return
    end

    # Method to redirect after successful authentication
    # This method should also handle the requests forwarded by the client for authentication
    def redirect_to_appropriate_page_after_sign_in
      if params[:redirect_back_url]
        redirect_to params[:redirect_back_url]+"?auth_token=#{@current_user.auth_token}"
      elsif params[:requested_url]
        redirect_to params[:requested_url]
      else
        redirect_to default_redirect_url_after_sign_in
      end
      return
    end

    def redirect_or_popup_to_default_sign_in_page
      respond_to do |format|
        format.html {
          redirect_after_unsuccessful_authentication
        }
        format.js {
          render(:partial => 'usman/sessions/sign_in.js.erb', :handlers => [:erb], :formats => [:js])
        }
      end
    end

    # This method is widely used to create the @current_user object from the session
    # This method will return @current_user if it already exists which will save queries when called multiple times
    def current_user
      # Check if the user exists with the auth token present in session
      @current_user = User.find_by_id(session[:id]) unless @current_user
      return @current_user
    end

    # This method is usually used as a before filter to secure some of the actions which requires the user to be signed in.
    def require_user
      current_user

      if @current_user
        if @current_user.token_expired?
          @current_user = nil
          session.delete(:id)
          
          text = "#{I18n.t("authentication.session_expired.heading")}: #{I18n.t("authentication.session_expired.message")}"
          set_flash_message(text, :error, false) if defined?(flash) && flash

          redirect_or_popup_to_default_sign_in_page
          return
        else
          @current_user.update_token if @current_user.token_about_to_expire?
        end
      else
        text = "#{I18n.t("authentication.permission_denied.heading")}: #{I18n.t("authentication.permission_denied.message")}"
        set_flash_message(text, :error, false) if defined?(flash) && flash

        redirect_or_popup_to_default_sign_in_page
        return
      end
    end

    # This method is usually used as a before filter from admin controllers to ensure that the logged in user is a super admin
    def require_super_admin
      unless @current_user.is_super_admin?
        text = "#{I18n.t("authentication.permission_denied.heading")}: #{I18n.t("authentication.permission_denied.message")}"
        set_flash_message(text, :error, false) if defined?(flash) && flash

        redirect_or_popup_to_default_sign_in_page
      end
    end

    # This method is only used for masquerading. When admin masquerade as user A and then as B, when he logs out as B he should be logged in back as A
    # This is accomplished by storing the last user id in session and activating it when user is logged off
    def restore_last_user
      return @last_user if @last_user
      if session[:last_user_id].present?
        @last_user = User.find_by_id(session[:last_user_id])
        message = translate("authentication.sign_in_back", user: @last_user.name)
        set_flash_message(message, :success, false)
        session.destroy()
        session[:id] = @last_user.id if @last_user.present?
        return @last_user
      end
    end

    def masquerade_as_user(user)
      message = translate("authentication.masquerade", user: user.name)
      set_flash_message(message, :success, false)
      session[:last_user_id] = current_user.id if current_user
      user.start_session
      session[:id] = user.id
      default_redirect_url_after_sign_in
      redirect_to default_redirect_url_after_sign_in
    end

  end
end
