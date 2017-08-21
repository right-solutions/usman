module Usman
  class MyAccountController < ApplicationController

    # GET /dashboard
    def index
    end

    private

    def breadcrumbs_configuration
      {
        heading: "My Account",
        description: "Manage Account, Profile & Settings",
        links: [{name: "Dashboard", link: dashboard_path, icon: 'fa-dashboard'},
                {name: "My Account", link: "#", icon: 'fa-user'}]
      }
    end

    def set_navs
      set_nav("usman/my_account")
    end

  end
end

