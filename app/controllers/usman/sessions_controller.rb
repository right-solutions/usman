module Usman 
  class SessionsController < Usman::ApplicationController

    layout 'kuppayam/blank'

    before_action :require_user, :only => :sign_out
    skip_before_action :set_navs
    
    def sign_in
      redirect_to_appropriate_page_after_sign_in if @current_user && !@current_user.token_expired?
    end

    def create_session
      @registration_details = Usman::AuthenticationService.new(params)
      if @registration_details.error
        set_notification_messages(@registration_details.error, :error)
        redirect_or_popup_to_default_sign_in_page
        return
      else
        @user = @registration_details.user
        session[:id] = @user.id
        @current_user = @user
        set_notification_messages("authentication.logged_in", :success)
        redirect_to_appropriate_page_after_sign_in
        return
      end
    end

    def sign_out
      set_notification_messages("authentication.logged_out", :success)
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

    def stylesheet_filename
      @stylesheet_filename = "kuppayam"
    end

    def javascript_filename
      @javascript_filename = "kuppayam"
    end

  end
end