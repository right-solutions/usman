Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  #SES Mailer
  # config.action_mailer.smtp_settings = {
  #   :address => "sanoop@rightsolutions.ae",
  #   :port => 587,
  #   :user_name => "sanoop", #Your SMTP user
  #   :password => "myid1729", #Your SMTP password
  #   :authentication => :login,
  #   :enable_starttls_auto => true
  # }

  # config.action_mailer.smtp_settings = {
  #   :address => "email-smtp.eu-west-1.amazonaws.com",
  #   :port => 587,
  #   :user_name => "AKIAJF233HBRKGKZG7RQ", #Your SMTP user
  #   :password => "Al5jmcj3OtHrm0fhJInlJnifySaT7REfxH4HY8gDOBj7", #Your SMTP password
  #   :authentication => :login,
  #   :enable_starttls_auto => true
  # }

  # Send in blue
  # config.action_mailer.smtp_settings = {
  #   :address => "smtp-relay.sendinblue.com",
  #   :port => 587,
  #   :user_name => "krishna@rightsolutions.ae", #Your SMTP user
  #   :password => "SJmERvck7OtKyCjB", #Your SMTP password
  #   :authentication => :login,
  #   :enable_starttls_auto => true
  # }

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    address: "smtp.mailgun.org",
    port: 587,
    domain: "notifier.sbidu.com",
    user_name: "postmaster@notifier.sbidu.com",
    password: "1044bccc0637290732949bcb7b4fb281",
    authentication: 'plain',
    enable_starttls_auto: true
  }

  # Gmail
  # config.action_mailer.smtp_settings = {
  #   address: "smtp.gmail.com",
  #   port: 465,
  #   domain: "gmail.com",
  #   user_name: "asd@gmail.com",
  #   password: "",
  #   authentication: 'plain',
  #   enable_starttls_auto: true
  # }
  
  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Local Precompilation - http://guides.rubyonrails.org/asset_pipeline.html#local-precompilation
  config.assets.prefix = "/dev-assets"

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
