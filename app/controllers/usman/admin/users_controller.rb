module Usman
  module Admin
    class UsersController < ResourceController

      def index
        @heading = "Manage Users"
        @description = "Listing all users"
        @links = [{name: "Dashboard", link: admin_dashboard_path, icon: 'fa-home'}, 
                  {name: "Manage Users", link: admin_users_path, icon: 'fa-user', active: true}]
        super
      end

      def create
        @user = User.new
        @user.assign_attributes(permitted_params)
        #@user.assign_default_password
        save_resource(@user)
        get_collections
      end

      def make_super_admin
        @user = User.find(params[:id])
        @user.update_attribute(:super_admin, true)
        render :row
      end

      def remove_super_admin
        @user = User.find(params[:id])
        @user.update_attribute(:super_admin, false)
        render :row
      end

      def update_status
        @user = User.find(params[:id])
        @user.update_attribute(:status, params[:status])
        render :row
      end

      def masquerade
        @user = User.find(params[:id])
        masquerade_as_user(@user)
      end

      private

      def get_collections
        # Fetching the users
        @relation = User.where("")

        parse_filters
        apply_filters
        
        @users = @relation.includes(:profile_picture).page(@current_page).per(@per_page)

        return true
      end

      def apply_filters
        @relation = @relation.search(@query) if @query
        @relation = @relation.status(@status) if @status
        
        # Normal users should not be able to view super admins
        # He should not be seeing admins even while searching
        if @current_user.is_super_admin?
          @relation = @relation.where("super_admin IS #{@super_admin.to_s.upcase}") if @super_admin.nil? == false && @query.nil?
        else
          @relation = @relation.where("super_admin IS FALSE")
        end

        @order_by = "created_at desc" unless @order_by
        @relation = @relation.order(@order_by)
      end

      def configure_filter_settings
        @filter_settings = {
          string_filters: [
            { filter_name: :query },
            { filter_name: :status }
          ],

          boolean_filters: [
            { filter_name: :super_admin, options: {default: false }}
          ],

          reference_filters: [],
          variable_filters: [],
        }
      end

      def configure_filter_ui_settings
        @filter_ui_settings = {
          status: {
            object_filter: false,
            select_label: "Select Status",
            display_hash: User::STATUS,
            current_value: @status,
            values: User::STATUS_REVERSE,
            current_filters: @filters,
            filters_to_remove: [],
            filters_to_add: {},
            url_method_name: 'admin_users_url',
            show_all_filter_on_top: true
          }
        }
      end

      def permitted_params
        params.require(:user).permit(:name, :username, :email, :designation, :phone, :password, :password_confirmation)
      end

      def set_navs
        set_nav("admin/users")
      end

    end
  end
end
