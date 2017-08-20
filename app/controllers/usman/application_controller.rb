module Usman
  class ApplicationController < Kuppayam::BaseController
    
    include Usman::AuthenticationHelper

    layout 'kuppayam/admin'
    
    before_action :current_user
    before_action :require_user
    before_action :require_site_admin

    private

    def set_default_title
      set_title("Usman Admin | User Management Module")
    end

    def require_site_admin
      return true if @current_user && @current_user.super_admin?
      unless @current_user && @current_user.has_role?("Site Admin")
        respond_to do |format|
          format.html {
            #text = "#{I18n.t("authentication.permission_denied.heading")}: #{I18n.t("authentication.permission_denied.message")}"
            #set_flash_message(text, :error, false) if defined?(flash) && flash
            redirect_after_unsuccessful_authentication
          }
          format.js {
            @params_hsh = {}
            @params_hsh[:client_app] = params[:client_app] if params[:client_app]
            @params_hsh[:redirect_back_url] = params[:redirect_back_url] if params[:redirect_back_url]
            @params_hsh[:requested_url] = request.original_url if request.get?
            
            render(:partial => 'usman/sessions/sign_in.js.erb', :handlers => [:erb], :formats => [:js])
          }
        end
      end
    end

    def configure_filter_param_mapping
      @filter_param_mapping = default_filter_param_mapping
      @filter_param_mapping[:super_admin] = :sa
      @filter_param_mapping[:user] = :us
      @filter_param_mapping[:feature] = :ft
    end

  end
end
