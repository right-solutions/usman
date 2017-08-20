module Usman
  class ResourceController < ApplicationController

  	include ResourceHelper

    before_action :require_user
  	before_action :require_site_admin
  	before_action :configure_resource_controller

    #def resource_url(obj)
	  #  url_for([:admin, obj])
	  #end

  end
end
