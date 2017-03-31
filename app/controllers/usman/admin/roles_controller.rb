module Usman
  module Admin
    class RolesController < ResourceController

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
        
        @order_by = "created_at desc" unless @order_by
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
          js_view_path: "/kuppayam/workflows/parrot",
          view_path: "/usman/admin/roles"
        }
      end

      def breadcrumbs_configuration
        {
          heading: "Manage Roles",
          description: "Listing all Roles",
          links: [{name: "Home", link: admin_dashboard_path, icon: 'fa-home'}, 
                    {name: "Manage Roles", link: admin_roles_path, icon: 'fa-calendar', active: true}]
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
end
