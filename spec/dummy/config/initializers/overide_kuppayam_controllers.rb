Kuppayam::BaseController.class_eval do
  
  def set_layout
    @current_layout = "materialize"
  end

end

Kuppayam::ImagesController.class_eval do
  
  include Usman::AuthenticationHelper

  before_action :current_user
  before_action :require_user
  before_action :require_site_admin
  
  def set_default_title
    set_title("Manage Images | Admin")
  end

end

Kuppayam::ImportDataController.class_eval do
  
  include Usman::AuthenticationHelper

  before_action :current_user
  before_action :require_user
  before_action :require_site_admin

  def set_default_title
    set_title("Manage Import Data | Admin")
  end

end

Kuppayam::DocumentsController.class_eval do
  
  include Usman::AuthenticationHelper

  before_action :current_user
  before_action :require_user
  before_action :require_site_admin
  
  def set_default_title
    set_title("Manage Documents | Admin")
  end

end

Kuppayam::ImportDataController.class_eval do
  
  include Usman::AuthenticationHelper

  before_action :current_user
  before_action :require_user
  before_action :require_site_admin

  def set_default_title
    set_title("Manage Import Data | Admin")
  end

end