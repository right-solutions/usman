module Usman
  module Admin
    class UsersController < ResourceController

      def make_super_admin
        @user = @r_object = User.find(params[:id])
        if @user
          @user.super_admin = true
          if @user.valid?
            @user.save
            set_notification(true, I18n.t('status.success'), I18n.t('state.changed', item: default_item_name.titleize, new_state: @user.status))
          else
            set_notification(false, I18n.t('status.error'), I18n.translate("error"), @user.errors.full_messages.join("<br>"))
          end
        else
          set_notification(false, I18n.t('status.not_found'), I18n.t('status.not_found', item: default_item_name.titleize))
        end
        render_row
      end

      def remove_super_admin
        @user = @r_object = User.find(params[:id])
        if @user
          @user.super_admin = false
          if @user.valid?
            @user.save
            set_notification(true, I18n.t('status.success'), I18n.t('state.changed', item: default_item_name.titleize, new_state: @user.status))
          else
            set_notification(false, I18n.t('status.error'), I18n.translate("error"), @user.errors.full_messages.join("<br>"))
          end
        else
          set_notification(false, I18n.t('status.not_found'), I18n.t('status.not_found', item: default_item_name.titleize))
        end
        render_row
      end

      def masquerade
        @user = @r_object = User.find(params[:id])
        masquerade_as_user(@user)
      end

      private

      def get_collections
        # Fetching the users
        @relation = User.includes(:profile_picture).where("")

        parse_filters
        apply_filters
        
        @users = @r_objects = @relation.page(@current_page).per(@per_page)

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

      def resource_controller_configuration
        {
          view_path: "usman/admin/users"
        }
      end

      def breadcrumbs_configuration
        {
          heading: "Manage Users",
          description: "Listing all Users",
          links: [{name: "Home", link: admin_dashboard_path, icon: 'fa-home'}, 
                    {name: "Manage Users", link: admin_users_path, icon: 'fa-user', active: true}]
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
