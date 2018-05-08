module Usman 
  class SessionsController < Kuppayam::BaseController

    include Usman::AuthenticationHelper
    
    rescue_from ActionController::InvalidAuthenticityToken, :with => :rescue_from_invalid_authenticity_token

    before_action :current_user
    before_action :require_user, :only => :sign_out
    skip_before_action :set_navs
    
    def sign_in
      set_title("Sign In")
      redirect_to_appropriate_page_after_sign_in if @current_user
    end

    def create_session
      set_title("Sign In")
      registration_params = { login_handle: params[:login_handle], password: params[:password], remote_ip: request.remote_ip}
      @registration_details = Usman::AuthenticationService.new(registration_params)

      if @registration_details.error
        
        text = "#{I18n.t("#{@registration_details.error}.heading")}: #{I18n.t("#{@registration_details.error}.message")}"
        set_flash_message(text, :error, false) if defined?(flash) && flash

        redirect_or_popup_to_default_sign_in_page
        return
      else
        @user = @registration_details.user
        session[:id] = @user.id
        @current_user = @user
        
        text = "#{I18n.t("authentication.logged_in.heading")}: #{I18n.t("authentication.logged_in.message")}"
        set_flash_message(text, :success, false) if defined?(flash) && flash

        redirect_to_appropriate_page_after_sign_in
        return
      end
    end

    def sign_out
      text = "#{I18n.t("authentication.logged_out.heading")}: #{I18n.t("authentication.logged_out.message")}"
      set_flash_message(text, :success, false) if defined?(flash) && flash

      @current_user.end_session
      session.delete(:id)
      restore_last_user
      redirect_after_unsuccessful_authentication
    end

    def forgot_password_form
    end

    def forgot_password
      @user = User.find_by_email(params[:email])
      if @user.present?
        @user.generate_reset_password_token
        @user.save
        UsersMailer.forgot_password(@user).deliver
      else
      end
      flash[:notice] = "A password reset link will be send to your email if the records matches."
      redirect_to root_path
    end

    def reset_password_form
      @user = User.find(params[:id])
    end

    def reset_password_update
      @user = User.find(params[:id])
      if @user.reset_password_token == user_params[:reset_password_token] && @user.update(user_params)
        @user.reset_password_token = nil
        @user.save
        flash[:success] = "Password updated successfully"
        redirect_to root_path
      else
        flash[:error] = "Unable to update password please try again later"
        render "reset_password_form"
      end
    end

    private

    def user_params
      params[:user].permit(:password, :password_confirmation, :reset_password_token)
    end
    
  end
end