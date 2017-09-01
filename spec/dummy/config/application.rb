require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "usman"

module Dummy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # TODO - fix autoload paths and railties order
    config.autoload_paths << "app/services"
    config.railties_order = [:main_app, Usman::Engine, Kuppayam::Engine, :all]
    
  end
end

