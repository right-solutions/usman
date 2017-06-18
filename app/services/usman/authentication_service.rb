module Usman
  class AuthenticationService

    attr_reader :login_handle, :password, :error, :user, :remote_ip

    def initialize(params)
      @login_handle = params[:login_handle]
      @password = params[:password]
      @remote_ip = params[:remote_ip]
      @error = nil
      
      check_if_user_exists
      if @user
        authenticate
        check_if_user_is_approved
      end

      @user.start_session(@remote_ip) unless @error
    end

    def invalid_login_error
      "authentication.invalid_login"
    end

    def user_status_error
      "authentication.user_is_#{@user.status.downcase}"
    end

    def check_if_user_exists
      @user = User.where("LOWER(email) = LOWER('#{@login_handle}') OR LOWER(username) = LOWER('#{@login_handle}')").first
      set_error(invalid_login_error) unless @user
    end

    def check_if_user_is_approved
      set_error(user_status_error) unless @user.approved?
    end

    def authenticate
      set_error(invalid_login_error) unless @user.authenticate(@password)
    end

    def set_error(id)
      @error ||= id
    end
  end
end