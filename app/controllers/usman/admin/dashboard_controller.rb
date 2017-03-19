module Usman
	module Admin
	  class DashboardController < Usman::Admin::BaseController

	    # GET /dashboard
	    def index
	    end

	    private

	    def set_navs
	      set_nav("admin/dashboard")
	    end

	  end
	end
end

