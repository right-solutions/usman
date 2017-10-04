module Usman
  class RolesController < ResourceController

    before_action :require_site_admin
    
    private

    def get_collections
      @relation = Role.where("")

      parse_filters
      apply_filters
      
      @roles = @r_objects = @relation.page(@current_page).per(@per_page)

      return true
    end

    def apply_filters
      @relation = @relation.search(@query) if @query
      
      @order_by = "name ASC" unless @order_by
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
        page_title: "Roles",
        js_view_path: "/kuppayam/workflows/peacock",
        view_path: "/usman/roles"
      }
    end

    def breadcrumbs_configuration
      {
        heading: "Manage Roles",
        icon: "fa-lock",
        description: "Listing all Roles",
        links: [{name: "Home", link: breadcrumb_home_path, icon: 'fa-home'}, 
                  {name: "Manage Roles", link: roles_path, icon: 'fa-calendar', active: true}]
      }
    end

    def permitted_params
      params.require(:role).permit(:name)
    end

    def set_navs
      set_nav("admin/roles")
    end

  end
end
