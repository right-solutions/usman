module Usman
  class UserRolesController < ResourceController

    before_action :require_site_admin
    before_action :get_role
    
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
      @user = @r_object = @resource_options[:class].find_by_id(params[:id])
      set_notification(false, I18n.t('status.error'), I18n.t('status.not_found', item: default_item_name.titleize)) unless @r_object
      render_accordingly
    end

    def new
      @user = User.new
      render_accordingly
    end

    def create
      @user = @r_object = User.find_by_id(permitted_params[:id])
      if @user.add_role(@role)
        set_notification(true, I18n.t('status.success'), "Role '#{@role.name}' has been assigned to the user '#{@user.name}'")
      else
        set_notification(false, I18n.t('status.success'), "Failed to assign the Role '#{@role.name}'")
      end
      action_name = params[:action].to_s == "create" ? "new" : "edit"
      render_or_redirect(false, resource_url(@r_object), action_name)
    end

    def destroy
      @user = @r_object = User.find_by_id(params[:id])
      if @user
        if @user.remove_role(@role)
          get_collections
          set_flash_message(I18n.t('success.deleted'), :success)
          set_notification(true, I18n.t('status.success'), "Role '#{@role.name}' has been removed for the user '#{@user.name}'")
          @destroyed = true
        else
          message = I18n.t('errors.failed_to_delete', item: default_item_name.titleize)
          set_flash_message(message, :failure)
          set_notification(false, I18n.t('status.success'), "Failed to remove the Role '#{@role.name}'")
          @destroyed = false
        end
      else
        set_notification(false, I18n.t('status.error'), I18n.t('status.not_found', item: default_item_name.titleize))
      end

      respond_to do |format|
        format.html {}
        format.js  { 
          js_view_path = @resource_options && @resource_options[:js_view_path] ? "#{@resource_options[:js_view_path]}/destroy" : :destroy 
          render js_view_path
        }
      end

    end

    private

    def get_role
      @role = Role.find_by_id(params[:role_id])
    end

    def get_collections
      @relation = @role.users.where("")

      parse_filters
      apply_filters
      
      @users = @r_objects = @relation.page(@current_page).per(@per_page)
      
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

    def resource_url(obj)
      url_for([@role, obj])
    end

    def resource_controller_configuration
      {
        collection_name: :users,
        item_name: :user,
        class: User,
        show_modal_after_create: false,
        show_modal_after_update: false,
        page_title: "Manage User Roles",
        js_view_path: "/kuppayam/workflows/parrot",
        view_path: "/usman/user_roles"
      }
    end

    def breadcrumbs_configuration
      {
        heading: "Manage User Roles",
        description: "Listing all User Roles",
        links: [{name: "Home", link: dashboard_path, icon: 'fa-home'}]
      }
    end

    def permitted_params
      params.require(:user).permit(:id)
    end

    def set_navs
      set_nav("admin/roles/user_roles")
    end

  end
end
