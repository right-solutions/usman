module Usman
  class FeaturesController < ResourceController

    before_action :require_super_admin

    def update_permission
      @permission = Permission.find_by_id(params[:permission_id])
      @user = User.find_by_id(params[:user_id])
      if @permission
        begin
          @permission.toggle!(params[:permission_for])
          @success = true
        rescue
          @success = false
        end
      else
        @permission = Permission.new(user: @user, can_read: false, feature_id: params[:id])
        @permission.assign_attributes(params[:permission_for] => true)
        if @permission.valid?
          @permission.save
          @success = true
        else
          @success = false
        end
      end
    end
    
    private

    def get_resource
      @r_object = @resource_options[:class].find_by_id(params[:id])
      @r_object.categorisable = false if params[:action] == "update"
    end

    def get_collections
      @relation = Feature.where("")

      parse_filters
      apply_filters
      
      @features = @r_objects = @relation.page(@current_page).per(@per_page)

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
          url_method_name: 'users_url',
          show_all_filter_on_top: true
        }
      }
    end

    def resource_controller_configuration
      {
        page_title: "Features",
        js_view_path: "/kuppayam/workflows/peacock",
        view_path: "/usman/features",
        show_modal_after_create: true,
        show_modal_after_update: true
      }
    end

    def breadcrumbs_configuration
      {
        heading: "Manage Features",
        icon: "lincons-diamond",
        description: "Listing all Features",
        links: [{name: "Home", link: breadcrumb_home_path, icon: 'fa-home'}, 
                  {name: "Manage Features", link: features_path, icon: 'fa-calendar', active: true}]
      }
    end

    def permitted_params
      params.require(:feature).permit(:name, :categorisable)
    end

    def set_navs
      set_nav("usman/features")
    end

  end
end
