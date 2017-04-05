module Usman
  module Admin
    class PermissionsController < ResourceController

      def create
        @permission = @r_object = Permission.where(" user_id = ? AND feature_id = ? ", permitted_params[:user_id], permitted_params[:feature_id]).first || Permission.new
        @permission.assign_attributes(permitted_params)
        save_resource
        get_collections
      end

      def update
        @permission = @r_object = Permission.find_by_id(params[:id])
        # The form will not submit can_create 0 if it is not selected
        # hence making it false by default and letting it update by itself.
        @permission.assign_attributes({"can_create": "0", "can_read": "0", "can_update": "0", "can_delete": "0"})
        @permission.assign_attributes(permitted_params)
        save_resource
        get_collections
      end

      private

      def get_collections
        @relation = Permission.where("")

        parse_filters
        apply_filters
        
        @permissions = @r_objects = @relation.includes(:user, :feature).page(@current_page).per(@per_page)

        return true
      end

      def apply_filters
        @relation = @relation.search(@query) if @query
        @order_by = "user_id DESC, created_at DESC" unless @order_by
        @relation = @relation.order(@order_by)
      end

      def configure_filter_settings
        @filter_settings = {
          string_filters: [{ filter_name: :query }],
          boolean_filters: [],
          reference_filters: [
            { filter_name: :user, filter_class: User },
            { filter_name: :feature, filter_class: Feature },
          ],
          variable_filters: [],
        }
      end

      def configure_filter_ui_settings
        @filter_ui_settings = {}
      end

      def resource_controller_configuration
        {
          page_title: "Permissions",
          js_view_path: "/kuppayam/workflows/parrot",
          view_path: "/usman/admin/permissions"
        }
      end

      def breadcrumbs_configuration
        {
          heading: "Manage Permissions",
          description: "Listing all Permissions",
          links: [{name: "Home", link: admin_dashboard_path, icon: 'fa-home'}, 
                    {name: "Manage Permissions", link: admin_permissions_path, icon: 'fa-calendar', active: true}]
        }
      end

      def permitted_params
        params.require(:permission).permit(:user_id, :feature_id, :can_create, :can_read, :can_update, :can_delete)
      end

      def set_navs
        set_nav("admin/permissions")
      end

    end
  end
end
