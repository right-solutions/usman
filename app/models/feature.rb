class Feature < Usman::ApplicationRecord
  
  # Constants
  PUBLISHED = "published"
  UNPUBLISHED = "unpublished"
  DISABLED = "disabled"
  
  STATUS = { 
    PUBLISHED => "Published", 
    UNPUBLISHED => "Un-Published", 
    DISABLED => "Disabled"
  }

  STATUS_REVERSE = { 
    "Published" => PUBLISHED,
    "Un-Published" => UNPUBLISHED,
    "Disabled" => DISABLED
  }
  
	# Associations
  has_many :permissions
  has_many :users, through: :permissions
  has_one :feature_image, :as => :imageable, :dependent => :destroy, :class_name => "Image::FeatureImage"

	# Validations
	validates :name, presence: true, length: {minimum: 3, maximum: 250}
	validates :status, :presence => true, :inclusion => {:in => STATUS.keys, :presence_of => :status, :message => "%{value} is not a valid status" }

  # ------------------
  # Class Methods
  # ------------------

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> feature.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| where("LOWER(name) LIKE LOWER('%#{query}%')")
                        }

  scope :status, lambda { |status| where("LOWER(status)='#{status}'") }

  scope :unpublished, -> { where(status: UNPUBLISHED) }
  scope :published, -> { where(status: PUBLISHED) }
  scope :disabled, -> { where(status: DISABLED) }

  def self.save_row_data(hsh)

    # Initializing error hash for displaying all errors altogether
    error_object = Kuppayam::Importer::ErrorHash.new

    return error_object if hsh[:name].blank?

    feature = Feature.find_by_name(hsh[:name]) || Feature.new
    feature.name = hsh[:name]
    feature.status = hsh[:status]
    
    if feature.valid?
      begin
        feature.save!
      rescue Exception => e
        summary = "uncaught #{e} exception while handling connection: #{e.message}"
        details = "Stack trace: #{e.backtrace.map {|l| "  #{l}\n"}.join}"
        error_object.errors << { summary: summary, details: details }        
      end
    else
      summary = "Error while saving feature: #{feature.name}"
      details = "Error! #{feature.errors.full_messages.to_sentence}"
      error_object.errors << { summary: summary, details: details }
    end
    return error_object
  end

  # ------------------
  # Instance Methods
  # ------------------

  # Status Methods
  # --------------

  # * Return true if the user is not published, else false.
  # == Examples
  #   >>> feature.published?
  #   => true
  def published?
    (status == PUBLISHED)
  end

  # * Return true if the user is unpublished, else false.
  # == Examples
  #   >>> feature.unpublished?
  #   => true
  def unpublished?
    (status == UNPUBLISHED)
  end

  # * Return true if the user is disabled, else false.
  # == Examples
  #   >>> feature.disabled?
  #   => true
  def disabled?
    (status == DISABLED)
  end

  # change the status to :unpublished
  # Return the status
  # == Examples
  #   >>> feature.unpublish!
  #   => "unpublished"
  def unpublish!
    self.update_attribute(:status, UNPUBLISHED)
  end

  # change the status to :published
  # Return the status
  # == Examples
  #   >>> feature.publish!
  #   => "published"
  def publish!
    self.update_attribute(:status, PUBLISHED)
  end

  # change the status to :suspended
  # Return the status
  # == Examples
  #   >>> feature.disable!
  #   => "disabled"
  def disable!
    self.update_attribute(:status, DISABLED)
  end

  # Permission Methods
  # ------------------

  def can_be_edited?
    published? or unpublished?
  end

  def can_be_deleted?
    true
  end

  def can_be_published?
    unpublished? or disabled?
  end

  def can_be_unpublished?
    published? or disabled?
  end

  def can_be_disabled?
    published? or unpublished?
  end

  # Other Methods
  # -------------

  # * Return full name
  # == Examples
  #   >>> feature.display_name
  #   => "Products"
  def display_name
    "#{name.to_s.demodulize.pluralize.titleize}"
  end
	
end