module Usman
  class Engine < ::Rails::Engine
    
    # require 'pry'
    require 'kaminari'
    require 'kuppayam'
    require 'pattana'
    require 'colorize'
    require 'colorized_string'
    
    isolate_namespace Usman

    config.before_initialize do                                                      
      config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]
    end

    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end

    initializer "usman.action_view" do |app|
      ActiveSupport.on_load :action_view do
        include Usman::ActionView::PermissionsHelper
      end
    end

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/dummy/spec/factories'
      g.assets false
      g.helper false
    end
    
  end
end
