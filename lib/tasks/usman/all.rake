require 'csv'
require 'open-uri'
require 'time'

RAILS_ENV = ENV["RAILS_ENV"] || "development"

namespace 'usman' do
  namespace 'import' do

    desc "Import all data in sequence"
    task 'all' => :environment do

      import_list = ["users", "features", "permissions"]
      
      import_list.each do |item|
        puts ""
        puts "Importing #{item.titleize}".yellow
        begin
          Rake::Task["usman:import:#{item}"].invoke
        rescue Exception => e
          puts "Importing #{item.titleize} - Failed - #{e.message}".red
          puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
        end
      end

    end

    namespace 'dummy' do
      desc "Import all dummy data in sequence"
      task 'all' => :environment do

        import_list = ["dummy:users", "dummy:features", "dummy:permissions"]
        
        import_list.each do |item|
          puts ""
          puts "Importing #{item}".yellow
          begin
            Rake::Task["usman:import:#{item}"].invoke
          rescue Exception => e
            puts "Importing #{item} - Failed - #{e.message}".red
            puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
          end
        end

      end
    end

  end
end