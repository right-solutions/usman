module Usman
  class ResourceController < ApplicationController

  	include ResourceHelper

    before_action :configure_resource_controller
    before_action :require_read_permission, only: [:index, :show]
    before_action :require_create_permission, only: [:new, :create]
    before_action :require_update_permission, only: [:edit, :update, :update_status, :mark_as_featured, :remove_from_featured]
    before_action :require_delete_permission, only: [:destroy]
    
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
