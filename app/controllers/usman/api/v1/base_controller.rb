module Usman
  module Api
    module V1
      class BaseController < ActionController::API

        include ActionController::HttpAuthentication::Token::ControllerMethods
        include ApiHelper
        include Usman::ApiHelper
        
        before_action :require_auth_token

      end
    end
  end
end
