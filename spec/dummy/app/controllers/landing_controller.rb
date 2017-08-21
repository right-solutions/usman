class LandingController < Kuppayam::BaseController

  include Usman::AuthenticationHelper
  
  before_action :current_user

	def index
    if @current_user.super_admin? || @current_user.has_role?("Site Admin")
  	 redirect_to usman.dashboard_url	
  	else
     redirect_to usman.my_account_url
  	end
  end

end

