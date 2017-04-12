module Usman
  class ApplicationRecord < ActiveRecord::Base
	  self.abstract_class = true

	  extend Kuppayam::Importer
	  extend Kuppayam::Validators
	end
end
