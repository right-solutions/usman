class Role < Usman::ApplicationRecord
  
  # Associations
  has_and_belongs_to_many :users

	# Validations
	validates :name, presence: true, length: {minimum: 3, maximum: 250}
	
  # ------------------
  # Class Methods
  # ------------------

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> role.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| where("LOWER(roles.name) LIKE LOWER('%#{query}%')")
                        }

  def self.save_row_data(hsh)

    return if hsh[:name].blank?

    role = Role.find_by_name(hsh[:name]) || Role.new
    role.name = hsh[:name]
    
    # Initializing error hash for displaying all errors altogether
    error_object = Kuppayam::Importer::ErrorHash.new

    if role.valid?
      begin
        role.save!
      rescue Exception => e
        summary = "uncaught #{e} exception while handling connection: #{e.message}"
        details = "Stack trace: #{e.backtrace.map {|l| "  #{l}\n"}.join}"
        error_object.errors << { summary: summary, details: details }        
      end
    else
      summary = "Error while saving role: #{role.name}"
      details = "Error! #{role.errors.full_messages.to_sentence}"
      error_object.errors << { summary: summary, details: details }
    end
    return error_object
  end

  # * Return full name
  # == Examples
  #   >>> role.display_name
  #   => "Products"
  def display_name
    "#{name}"
  end

  def can_be_edited?
    true
  end

  def can_be_deleted?
    self.users.count > 0 ? false : true
  end
	
end