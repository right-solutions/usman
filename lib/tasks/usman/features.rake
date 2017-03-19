require 'csv'
require 'open-uri'
require 'time'

RAILS_ENV = ENV["RAILS_ENV"] || "development" unless defined?(RAILS_ENV)

namespace 'usman' do
  namespace 'import' do
    desc "Import Features"
    task 'features' => :environment do
      verbose = true
      verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)
      Feature.import_from_csv(false, verbose)
    end
    namespace 'dummy' do
      desc "Load Dummy Features"
      task 'features' => :environment do
        path = "db/import_data/dummy/features.csv"
        verbose = true
        verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)
        Feature.import_from_csv(true, verbose)
      end
    end
  end

end