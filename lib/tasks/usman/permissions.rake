require 'csv'
require 'open-uri'
require 'time'

RAILS_ENV = ENV["RAILS_ENV"] || "development" unless defined?(RAILS_ENV)

namespace 'usman' do
  namespace 'import' do
    desc "Import Permissions"
    task 'permissions' => :environment do
      verbose = true
      verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)
      Permission.import_from_csv(false, verbose)
    end
    namespace 'dummy' do
      desc "Load Dummy Permissions"
      task 'permissions' => :environment do
        path = "db/import_data/dummy/permissions.csv"
        verbose = true
        verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)
        Permission.import_from_csv(true, verbose)
      end
    end
  end

end