require 'csv'
require 'open-uri'
require 'time'

namespace 'usman' do
  namespace 'import' do
    namespace 'master_data' do

      desc "Import all data in sequence"
      task 'all_usman' => :environment do

        import_list = ["roles"]
        
        import_list.each do |item|
          print "Importing #{item.titleize} \t".yellow
          begin
            Rake::Task["usman:import:master_data:#{item}"].invoke
          rescue ArgumentError => e
              puts "Loading #{item} - Failed - #{e.message}".red
          rescue Exception => e
            puts "Importing #{item.titleize} - Failed - #{e.message}".red
            puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
          end
        end
        puts " "
      end

      ["Role"].each do |cls_name|
        name = cls_name.underscore.pluralize
        desc "Import #{cls_name.pluralize}"
        task name => :environment do
          verbose = true
          verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)
          path = Usman::Engine.root.join('db', 'master_data', "#{cls_name.constantize.table_name}.csv")
          cls_name.constantize.destroy_all
          cls_name.constantize.import_data_file(path, true, verbose)
          # puts "Importing Completed".green if verbose
        end
      end

    end
  end
end
    