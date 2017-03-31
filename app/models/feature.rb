class Feature < Usman::ApplicationRecord
  
  require 'import_error_handler.rb'
  extend Usman::ImportErrorHandler
  
  # Constants
  UNPUBLISHED = "unpublished"
  PUBLISHED = "published"
  DISABLED = "disabled"
  
  STATUS = { 
    UNPUBLISHED => "Un-Published", 
    PUBLISHED => "Published", 
    DISABLED => "Disabled"
  }

  STATUS_REVERSE = { 
    "Un-Published" => UNPUBLISHED, 
    "Published" => PUBLISHED, 
    "Disabled" => DISABLED
  }
  
	# Associations
  has_many :permissions
  has_many :users, through: :permissions
  has_one :feature_image, :as => :imageable, :dependent => :destroy, :class_name => "Image::FeatureImage"

	# Validations
	validates :name, presence: true
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

  def self.save_row_data(row, base_path)

    image_base_path = base_path + "images/"

    row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }

    return if row[:name].blank?

    feature = Feature.find_by_name(row[:name]) || Feature.new
    feature.name = row[:name]
    feature.status = Feature::UNPUBLISHED
    
    # Initializing error hash for displaying all errors altogether
    error_object = Usman::ErrorHash.new

    ## Adding a profile picture
    begin
      image_path = image_base_path + "features/#{feature.name.parameterize}.png"
      image_path = image_base_path + "features/#{feature.name.parameterize}}.jpg" unless File.exists?(image_path)
      if File.exists?(image_path)
        feature.build_feature_image
        feature.feature_image.image = File.open(image_path)
      else
        summary = "Feature Image not found for feature: #{feature.name}"
        details = "#{image_path}/png doesn't exists"
        error_object.warnings << { summary: summary, details: details }
      end
    rescue => e
      summary = "Error during processing: #{$!}"
      details = "Feature: #{feature.name}, Image Path: #{image_path}"
      stack_trace = "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
      error_object.errors << { summary: summary, details: details, stack_trace: stack_trace }
    end if feature.feature_image.blank?

    if feature.valid? && (feature.feature_image.blank? || feature.feature_image.valid?)
      feature.save!
    else
      summary = "Error while saving feature: #{feature.name}"
      details = "Error! #{feature.errors.full_messages.to_sentence}"
      details << ", #{feature.feature_image.errors.full_messages.to_sentence}" if feature.feature_image
      error_object.errors << { summary: summary, details: details }
    end
    return error_object
  end

  # * Return full name
  # == Examples
  #   >>> feature.display_name
  #   => "Products"
  def display_name
    "#{name}"
  end

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
  #   >>> feature.suspend!
  #   => "suspended"
  def suspend!
    self.update_attribute(:status, DISABLED)
  end

  def can_be_destroyed?
    return true
  end
	
end