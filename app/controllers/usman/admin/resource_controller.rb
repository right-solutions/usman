module Usman
	module Admin
	  class ResourceController < Usman::Admin::BaseController

	  	include ResourceHelper

	    before_action :configure_resource_controller

	  end
	end
end
