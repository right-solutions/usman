module Usman
  module Api
    module V1
      class BaseController < ActionController::API

        include ActionController::HttpAuthentication::Token::ControllerMethods
        include RenderApiHelper
        include Usman::ApiHelper
        
        before_action :require_api_token
        after_action :store_last_accessed_api

      end
    end
  end
end
