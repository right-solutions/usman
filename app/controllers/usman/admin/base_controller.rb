module Usman
  module Admin
    class BaseController < ApplicationController
      
      layout 'kuppayam/admin'
      
      before_action :require_user
      before_action :require_site_admin
      
      private

      def set_default_title
        set_title("Usman Admin | User Management Module")
      end

      def require_site_admin
        return true if @current_user && @current_user.super_admin?
        unless @current_user && @current_user.has_role?("Site Admin")
          text = "#{I18n.t("authentication.permission_denied.heading")}: #{I18n.t("authentication.permission_denied.message")}"
          set_flash_message(text, :error, false) if defined?(flash) && flash
          redirect_to default_redirect_url_after_sign_in
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
end
