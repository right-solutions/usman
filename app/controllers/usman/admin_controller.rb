module Usman
  class AdminController < Kuppayam::BaseController
    
    include Usman::AuthenticationHelper

    layout 'kuppayam/admin'
    
    before_action :current_user
    before_action :require_user
    before_action :require_site_admin

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

  end
end
