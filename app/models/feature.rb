class Feature < ApplicationRecord
  
  extend KuppayamValidators

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
	validate_string :name, mandatory: true
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