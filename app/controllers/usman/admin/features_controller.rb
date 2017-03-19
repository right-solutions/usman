module Usman
  module Admin
    class FeaturesController < ResourceController

      def index
        @heading = "Manage Features"
        @description = "Listing all features"
        @links = [{name: "Dashboard", link: admin_dashboard_path, icon: 'fa-home'}, 
                  {name: "Manage Features", link: admin_features_path, icon: 'fa-user', active: true}]
        super
      end

      def create
        @feature = Feature.new
        @feature.assign_attributes(permitted_params)
        save_resource(@feature)
        get_collections
      end

      def update_status
        @feature = Feature.find(params[:id])
        @feature.update_attribute(:status, params[:status])
        render :row
      end

      private

      def get_collections
        @relation = Feature.where("")

        parse_filters
        apply_filters
        
        @features = @relation.includes(:feature_image).page(@current_page).per(@per_page)

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

      def permitted_params
        params.require(:feature).permit(:name)
      end

      def set_navs
        set_nav("admin/features")
      end

    end
  end
end
