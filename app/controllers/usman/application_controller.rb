module Usman
  class ApplicationController < Kuppayam::BaseController
    
    include Usman::AuthenticationHelper

    layout 'kuppayam/admin'
    
    before_action :current_user
    before_action :require_user
    
    private

    def set_default_title
      set_title("Usman Admin | User Management Module")
    end

    def configure_filter_param_mapping
      @filter_param_mapping = default_filter_param_mapping
      @filter_param_mapping[:super_admin] = :sa
      @filter_param_mapping[:user] = :us
      @filter_param_mapping[:feature] = :ft
    end

    def breadcrumb_home_path
      usman.dashboard_path
    end

  end
end
