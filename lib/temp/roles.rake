require 'csv'
require 'open-uri'
require 'time'

namespace 'usman' do
  namespace 'import' do
    desc "Import Roles"
    task 'roles' => :environment do
      verbose = true
      verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)
      path = ENV['path']
      Role.import_data(Usman::Engine, path, false, verbose)
    end
    namespace 'dummy' do
      desc "Load Dummy Roles"
      task 'roles' => :environment do
        verbose = true
        verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)
        Role.import_data(Usman::Engine, nil, true, verbose)        
      end
    end
  end

end