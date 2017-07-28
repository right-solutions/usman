ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'pry'
require 'carrierWave'
require 'carrierwave/orm/activerecord'
#require 'rspec/autorun'
require 'shoulda/matchers'
require 'factory_girl_rails'


# Load Dummy Factories
ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), 'dummy/')
Dir[File.join(ENGINE_RAILS_ROOT, "spec/factories/**/*.rb")].each {|f| require f }

Rails.backtrace_cleaner.remove_silencers!

ActiveRecord::Migrator.migrations_paths = 'spec/dummy/db/migrate'

# Load support files
#Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation  # clean DB of any leftover data
    DatabaseCleaner.strategy = :transaction # rollback transactions between each test
  end

  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

