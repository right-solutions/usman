module Usman
  class ApplicationRecord < ActiveRecord::Base
	  self.abstract_class = true

	  #require 'kuppayam/importer.rb'
	  extend Kuppayam::Importer
	  extend Kuppayam::Validators
	end
end
