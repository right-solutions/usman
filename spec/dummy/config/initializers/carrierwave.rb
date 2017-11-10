require 'carrierwave'
CarrierWave.configure do |config|
  if Rails.env.test? || Rails.env.cucumber?
	 	config.storage = :file
	 	config.enable_processing = false
	 	config.root = "#{Rails.root}/tmp"
	elsif Rails.env.development?
	 	config.storage = :file
	end
end

