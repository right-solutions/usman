module Usman
  module Admin
    class FeaturesController < ResourceController

      private

      def get_collections
        @relation = Feature.where("")

        parse_filters
        apply_filters
        
        @features = @r_objects = @relation.includes(:feature_image).page(@current_page).per(@per_page)

        return true
      end

      def apply_filters
        @relation = @relation.search(@query) if @query
        @relation = @relation.status(@status) if @status
        
        @order_by = "created_at desc" unless @order_by
        @relation = @relation.order(@order_by)
      end

      def configure_filter_settings
        @filter_settings = {
          string_filters: [
            { filter_name: :query },
            { filter_name: :status }
          ],
          boolean_filters: [],
          reference_filters: [],
          variable_filters: [],
        }
      end

      def configure_filter_ui_settings
        @filter_ui_settings = {
          status: {
            object_filter: false,
            select_label: "Select Status",
            display_hash: Feature::STATUS,
            current_value: @status,
            values: Feature::STATUS_REVERSE,
            current_filters: @filters,
            filters_to_remove: [],
            filters_to_add: {},
            url_method_name: 'admin_users_url',
            show_all_filter_on_top: true
          }
        }
      end

      def resource_controller_configuration
        {
          page_title: "Features",
          js_view_path: "/kuppayam/workflows/parrot",
          view_path: "/usman/admin/features"
        }
      end

      def breadcrumbs_configuration
        {
          heading: "Manage Features",
          icon: "lincons-diamond",
          description: "Listing all Features",
          links: [{name: "Home", link: admin_dashboard_path, icon: 'fa-home'}, 
                    {name: "Manage Features", link: admin_features_path, icon: 'fa-calendar', active: true}]
        }
      end

      def permitted_params
        params.require(:feature).permit(:name)
      end

      def set_navs
        set_nav("admin/features")
      end

    end
  end
end
