module Usman
  class ResourceController < ApplicationController

  	include ResourceHelper
    before_action :configure_resource_controller

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
