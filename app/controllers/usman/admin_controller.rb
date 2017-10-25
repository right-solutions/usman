module Usman
  class AdminController < Usman::ApplicationController
    
    before_action :require_site_admin

    private

  end
end
