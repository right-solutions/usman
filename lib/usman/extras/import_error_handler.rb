module Usman
	class ErrorHash

		require 'colorized_string'

		attr_accessor :warnings,
	                :errors

	  def initialize
	  	@warnings = []
	    @errors = []
	  end

	  def warnings?
	  	@warnings.any?
	  end

	  def errors?
	  	@errors.any?
	  end

	  def print_dot
	  	if self.warnings?
        print ".".yellow
      elsif self.errors?
        print ".".red
      else
        print ".".green
      end
	  end

	  def print_all
	  	self.warnings.each do |item|
        puts "Summary: #{item[:summary]}".yellow
        puts "Details: #{item[:details]}".yellow if item[:details]
        puts "Stack Trace: #{item[:stack_trace]}".yellow if item[:stack_trace]
        puts ""
	  	end
	  	self.errors.each do |item|
        puts "Summary: #{item[:summary]}".red
        puts "Details: #{item[:details]}".red if item[:details]
        puts "Stack Trace: #{item[:stack_trace]}".red if item[:stack_trace]
        puts ""
	  	end
	  end
	end

	module ImportErrorHandler
		def import_from_csv(dummy=true, verbose=true)
    
	    if dummy
	      folder_path = "/import_data/dummy/"
	    else
	      folder_path = "/import_data/"
	    end

	    base_path = File.expand_path('../../../../db/', __FILE__) + folder_path
	    csv_path = File.expand_path(base_path + "#{self.table_name}.csv")

	    csv_table = CSV.table(csv_path, {headers: true, converters: nil, header_converters: :symbol})
	    headers = csv_table.headers

	    errors = []

	    csv_table.each do |row|
	      error_object = save_row_data(row, base_path)
	      errors << error_object if error_object
	      error_object.print_dot if error_object
	    end

	    if verbose
	      puts ""
	      errors.each do |error_object|
	        error_object.print_all if error_object
	      end
	    end
	  end
	end
end