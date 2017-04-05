require 'csv'
require 'open-uri'
require 'time'

namespace 'usman' do
  namespace 'import' do
    desc "Import Features"
    task 'features' => :environment do
      verbose = true
      verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)
      path = ENV['path']
      Feature.import_data(Usman::Engine, path, false, verbose)
    end
    namespace 'dummy' do
      desc "Load Dummy Features"
      task 'features' => :environment do
        verbose = true
        verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)
        Feature.import_data(Usman::Engine, nil, true, verbose)                
      end
    end
  end
end