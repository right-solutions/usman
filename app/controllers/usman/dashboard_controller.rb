module Usman
  class DashboardController < AdminController

    before_action :require_site_admin
    
  	# GET /dashboard
    def index
    end

    private

    def breadcrumbs_configuration
      {
        heading: "User Dashboard",
        description: "A Quick view of users and roles",
        links: [{name: "Dashboard", link: dashboard_path, icon: 'fa-dashboard'}]
      }
    end

    def set_navs
      set_nav("usman/dashboard")
    end

  end
end

