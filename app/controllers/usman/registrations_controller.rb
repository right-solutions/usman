module Usman
  class RegistrationsController < ResourceController

    before_action :require_site_admin
    
    private

    def get_collections
      @relation = Registration.where("")

      parse_filters
      apply_filters
      
      @registrations = @r_objects = @relation.page(@current_page).per(@per_page)

      return true
    end

    def apply_filters
      @relation = @relation.search(@query) if @query
      
      @order_by = "created_at DESC" unless @order_by
      @relation = @relation.order(@order_by)
    end

    def configure_filter_settings
      @filter_settings = {
        string_filters: [
          { filter_name: :query }
        ],
        boolean_filters: [],
        reference_filters: [],
        variable_filters: [],
      }
    end

    def configure_filter_ui_settings
      @filter_ui_settings = {}
    end

    def resource_controller_configuration
      {
        page_title: "Registrations",
        js_view_path: "/kuppayam/workflows/peacock",
        view_path: "/usman/registrations"
      }
    end

    def breadcrumbs_configuration
      {
        heading: "Manage Registrations",
        icon: "fa-lock",
        description: "Listing all Registrations",
        links: [{name: "Home", link: dashboard_path, icon: 'fa-home'}, 
                  {name: "Manage Registrations", link: registrations_path, icon: 'fa-calendar', active: true}]
      }
    end

    def permitted_params
      params.require(:registration).permit(:mobile_number, :dialing_prefix, :country_id, :city_id)
    end

    def set_navs
      set_nav("admin/registrations")
    end

  end
end
