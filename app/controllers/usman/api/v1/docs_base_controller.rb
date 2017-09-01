module Usman
  module Api
    module V1
      class DocsBaseController < Kuppayam::BaseController

        include Usman::AuthenticationHelper
        
        layout 'kuppayam/docs'

        before_action :current_user

        private

        def breadcrumbs_configuration
          {
            heading: "Usman - API Documentation",
            description: "A brief documentation of all APIs implemented in the gem Usman with input and output details and examples",
            links: []
          }
        end
        
      end
    end
  end
end
