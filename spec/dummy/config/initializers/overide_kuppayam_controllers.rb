Kuppayam::ImagesController.class_eval do
  
  include Usman::AuthenticationHelper

  layout 'kuppayam/admin'

  before_action :current_user
  before_action :require_user
  before_action :require_site_admin
  
  def set_default_title
    set_title("Manage Images | Admin")
  end

  def require_site_admin
    return true if @current_user && @current_user.super_admin?
    unless @current_user.has_role?("Site Admin")
      text = "#{I18n.t("authentication.permission_denied.heading")}: #{I18n.t("authentication.permission_denied.message")}"
      set_flash_message(text, :error, false) if defined?(flash) && flash
      redirect_to default_redirect_url_after_sign_in
    end
  end

end

Kuppayam::ImportDataController.class_eval do
  
  include Usman::AuthenticationHelper

  layout 'kuppayam/admin'

  before_action :current_user
  before_action :require_user
  before_action :require_site_admin

  def set_default_title
    set_title("Manage Images | Admin")
  end

  def require_site_admin
    return true if @current_user && @current_user.super_admin?
    unless @current_user.has_role?("Site Admin")
      text = "#{I18n.t("authentication.permission_denied.heading")}: #{I18n.t("authentication.permission_denied.message")}"
      set_flash_message(text, :error, false) if defined?(flash) && flash
      redirect_to default_redirect_url_after_sign_in
    end
  end

end

Kuppayam::DocumentsController.class_eval do
  
  include Usman::AuthenticationHelper

  layout 'kuppayam/admin'

  before_action :current_user
  before_action :require_user
  before_action :require_site_admin

  def set_default_title
    set_title("Manage Images | Admin")
  end

  def require_site_admin
    return true if @current_user && @current_user.super_admin?
    unless @current_user.has_role?("Site Admin")
      text = "#{I18n.t("authentication.permission_denied.heading")}: #{I18n.t("authentication.permission_denied.message")}"
      set_flash_message(text, :error, false) if defined?(flash) && flash
      redirect_to default_redirect_url_after_sign_in
    end
  end

end