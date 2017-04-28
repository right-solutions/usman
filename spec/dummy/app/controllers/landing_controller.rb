class LandingController < Usman::ApplicationController

	def index
  	#redirect_to vyapari.admin_countries_url
  	if @current_user.super_admin? || @current_user.has_role?("Site Admin")
  		redirect_to usman.admin_dashboard_url
  	else
      redirect_to vyapari.user_dashboard_url
  	end
  end

end

