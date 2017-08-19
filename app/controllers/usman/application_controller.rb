module Usman
  class ApplicationController < Kuppayam::BaseController
    
    include Usman::AuthenticationHelper

    before_action :current_user

  end
end
