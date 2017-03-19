module Usman
  module Admin
    class BaseController < ApplicationController
      
      layout 'kuppayam/admin'
      
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
      
    end	
  end
end
