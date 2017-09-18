module Usman
  class RegistrationDevicesController < ResourceController

    before_action :require_site_admin
    before_action :get_registration
    
    def index
      get_collections
      respond_to do |format|
        format.html {}
        format.js  { 
          js_view_path = @resource_options && @resource_options[:js_view_path] ? "#{@resource_options[:js_view_path]}/index" : :index 
          render js_view_path
        }
      end
    end

    def show
      @device = @r_object = @resource_options[:class].find_by_id(params[:id])
      set_notification(false, I18n.t('status.error'), I18n.t('status.not_found', item: default_item_name.titleize)) unless @r_object
      render_accordingly
    end

    private

    def get_registration
      @registration = Registration.find_by_id(params[:registration_id])
    end

    def get_collections
      @relation = @registration.devices.where("")

      parse_filters
      apply_filters
      
      @devices = @r_objects = @relation.page(@current_page).per(@per_page)
      
      return true
    end

    def apply_filters
      @relation = @relation.search(@query) if @query
      
      @order_by = "devices.created_at DESC" unless @order_by
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

    def resource_url(obj)
      url_for([@registration, obj])
    end

    def resource_controller_configuration
      {
        collection_name: :devices,
        item_name: :device,
        class: Device,
        show_modal_after_create: false,
        show_modal_after_update: false,
        page_title: "Manage Device Registrations",
        js_view_path: "/kuppayam/workflows/parrot",
        view_path: "/usman/registration_devices"
      }
    end

    def breadcrumbs_configuration
      {
        heading: "Manage Device Registrations",
        description: "Listing all Device Registrations",
        links: [{name: "Home", link: dashboard_path, icon: 'fa-home'}]
      }
    end

    def permitted_params
      params.require(:device).permit(:id)
    end

    def set_navs
      set_nav("admin/registrations")
    end

  end
end
