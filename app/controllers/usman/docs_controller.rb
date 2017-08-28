module Usman
  class DocsController < Kuppayam::BaseController

    include Usman::AuthenticationHelper

    layout 'kuppayam/docs'

    before_action :current_user

    def index
    end

    def register
    end

    def resend_otp
    end

    def verify
    end

    private

    def set_default_title
      set_title("API Docs | #{params[:action].to_s.titleize}")
    end

    def breadcrumbs_configuration
      {
        heading: "API Documentation",
        description: "Requests and response structures with examples",
        links: [{name: "Index", link: docs_index_path, icon: 'fa-list'}]
      }
    end

    def set_navs
      set_nav("docs")
    end

  end
end
