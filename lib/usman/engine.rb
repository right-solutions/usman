module Usman
  class Engine < ::Rails::Engine
    require 'kuppayam'
  	require 'kaminari'
    isolate_namespace Usman

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/dummy/spec/factories'
      g.assets false
      g.helper false
    end
  end
end
