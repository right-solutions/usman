module Usman
  module ActionView
    # This module creates Bootstrap wrappers around basic View Tags
    module PermissionsHelper
      
      # -------------------
      # Display Helpers
      # -------------------

      def display_edit_links?
        @current_user.super_admin? || @current_permission.can_update?
      end

      def display_delete_links?
        @current_user.super_admin? || @current_permission.can_delete?
      end

      def display_manage_links?
        display_edit_links? || display_delete_links?
      end

    end
  end
end
