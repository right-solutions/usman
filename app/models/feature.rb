class Feature < Usman::ApplicationRecord
  
  # Including the State Machine Methods
  include Publishable

  # Associations
  has_many :permissions
  has_many :users, through: :permissions
  # has_one :feature_image, :as => :imageable, :dependent => :destroy, :class_name => "Image::FeatureImage"

	# Validations
	validates :name, presence: true, length: {minimum: 3, maximum: 250}
	
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

  scope :categorisable, -> { where(categorisable: true) }

  def self.save_row_data(hsh)

    # Initializing error hash for displaying all errors altogether
    error_object = Kuppayam::Importer::ErrorHash.new

    return error_object if hsh[:name].to_s.strip.blank?

    feature = Feature.find_by_name(hsh[:name].to_s.strip) || Feature.new
    feature.name = hsh[:name].to_s.strip
    feature.status = hsh[:status].to_s.strip
    feature.categorisable = hsh[:categorisable].to_s.strip
    
    if feature.valid?
      begin
        feature.save!
        # puts "#{feature.name} saved".green
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

  # Permission Methods
  # ------------------

  def can_be_edited?
    published? or unpublished?
  end

  def can_be_deleted?
    true
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

  def display_categorisable
    self.categorisable ? "Yes" : "No"
  end

  # Image Configuration
  # -------------------
  def image_configuration
    {
      "Image::FeaturePicture" => {
        max_upload_limit: 1048576,
        min_upload_limit: 1024,
        resolutions: [400, 400],
        form_upload_image_label: "Upload a new Image",
        form_title: "Upload an Image (Feature)",
        form_sub_title: "Please read the instructions below:",
        form_instructions: [
          "the filename should be in .jpg / .jpeg or .png format",
          "the image resolutions should be <strong>400 x 400 Pixels</strong>",
          "the file size should be greater than 100 Kb and or lesser than <strong>10 MB</strong>"
        ]
      }
    }
  end
	
end