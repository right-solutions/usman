module Usman
	module Admin
	  class DashboardController < Usman::Admin::BaseController

	  	# GET /dashboard
	    def index
	    end

	    private

	    def breadcrumbs_configuration
	      {
	        heading: "Usman Dashboard",
	        description: "A Quick view of users and roles",
	        links: [{name: "Dashboard", link: admin_dashboard_path, icon: 'fa-dashboard'}]
	      }
	    end

	    def set_navs
	      set_nav("admin/dashboard")
	    end

	  end
	end
end

