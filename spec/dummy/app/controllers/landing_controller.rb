class LandingController < Usman::ApplicationController

	def index
    redirect_to usman.dashboard_url
  	#if @current_user.super_admin? || @current_user.has_role?("Site Admin")
  	#	
  	#else
    #  redirect_to usman.profile_dashboard_url
  	#end
  end

end

