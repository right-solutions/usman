require 'csv'
require 'open-uri'
require 'time'

namespace 'usman' do
  namespace 'import' do
    namespace 'data' do

      desc "Import all data in sequence"
      task 'all' => :environment do

        import_list = ["users", "features", "permissions", "roles"]
        
        import_list.each do |item|
          print "Importing #{item.titleize} \t".yellow
          begin
            Rake::Task["usman:import:data:#{item}"].invoke
          rescue ArgumentError => e
              puts "Loading #{item} - Failed - #{e.message}".red
          rescue Exception => e
            puts "Importing #{item.titleize} - Failed - #{e.message}".red
            puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
          end
        end
        puts " "
      end

      ["Feature", "User", "Role", "Permission"].each do |cls_name|
        name = cls_name.underscore.pluralize
        desc "Import #{cls_name.pluralize}"
        task name => :environment do
          verbose = true
          verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)
          
          path = Rails.root.join('db', 'data', "#{cls_name.constantize.table_name}.csv")
          path = Usman::Engine.root.join('db', 'data', "#{cls_name.constantize.table_name}.csv") unless File.exists?(path)
          
          cls_name.constantize.destroy_all
          cls_name.constantize.import_data_file(path, true, verbose)
          puts "Importing Completed".green if verbose
        end
      end

      namespace 'dummy' do
        
        desc "Import all dummy data in sequence"
        task 'all' => :environment do

          import_list = ["users", "features", "permissions", "roles"]
          
          import_list.each do |item|
            print "Loading #{item.split(':').last.titleize} \t".yellow
            begin
              Rake::Task["usman:import:data:dummy:#{item}"].invoke
            rescue ArgumentError => e
              puts "Loading #{item} - Failed - #{e.message}".red
            rescue Exception => e
              puts "Loading #{item} - Failed - #{e.message}".red
              puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
            end
          end
          puts " "
        end

        ["Feature", "User", "Role", "Permission"].each do |cls_name|
          name = cls_name.underscore.pluralize
          desc "Load Dummy #{cls_name.pluralize}"
          task name => :environment do
            verbose = true
            verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)
            
            path = Rails.root.join('db', 'data', 'dummy', "#{cls_name.constantize.table_name}.csv")
            path = Usman::Engine.root.join('db', 'data', 'dummy', "#{cls_name.constantize.table_name}.csv") unless File.exists?(path)

            cls_name.constantize.destroy_all
            cls_name.constantize.import_data_file(path, true, verbose)
            puts "Importing Completed".green if verbose
          end
        end
      end

    end
  end
end
    