class Registration < ApplicationRecord
  
  # Constants
  EXCLUDED_JSON_ATTRIBUTES = [:status, :created_at, :updated_at]

  PENDING = "pending"
  VERIFIED = "verified"
  
  STATUS = { 
    PENDING => "Pending", 
    VERIFIED => "Verified"
  }

  STATUS_REVERSE = { 
    "Pending" => PENDING,
    "Verified" => VERIFIED
  }
  
	# Associations
  belongs_to :user, optional: true
  belongs_to :country
  belongs_to :city, optional: true
  has_many :devices

	# Validations
  validates :dialing_prefix, presence: true, length: {minimum: 2, maximum: 4}
	validates :mobile_number, presence: true, length: {minimum: 9, maximum: 11}
	validates :status, :presence => true, :inclusion => {:in => STATUS.keys, :presence_of => :status, :message => "%{value} is not a valid status" }

  # ------------------
  # Class Methods
  # ------------------

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> registration.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| joins("LEFT JOIN users on users.id = registrations.user_id").
                                where("LOWER(registrations.mobile_number) LIKE LOWER('%#{query}%') OR 
                                       LOWER(users.name) LIKE LOWER('%#{query}%')")}
  scope :status, lambda { |status| where("LOWER(status)='#{status}'") }

  scope :pending, -> { where(status: PENDING) }
  scope :verified, -> { where(status: VERIFIED) }

  # ------------------
  # Instance Methods
  # ------------------

  # Exclude some attributes info from json output.
  def as_json(options={})
    options[:except] ||= EXCLUDED_JSON_ATTRIBUTES
    #options[:include] ||= []
    #options[:methods] = []
    #options[:methods] << :profile_image
    json = super(options)
    Hash[*json.map{|k, v| [k, v || ""]}.flatten]
  end

  # Status Methods
  # --------------

  # * Return true if the user is pending, else false.
  # == Examples
  #   >>> registration.pending?
  #   => true
  def pending?
    (status == PENDING)
  end

  # * Return true if the user is not verified, else false.
  # == Examples
  #   >>> registration.verified?
  #   => true
  def verified?
    (status == VERIFIED)
  end

  # change the status to :verified
  # Return the status
  # == Examples
  #   >>> registration.pending!
  #   => "pending"
  def pending!
    self.update_attribute(:status, PENDING)
  end

  # change the status to :verified
  # Return the status
  # == Examples
  #   >>> registration.verify!
  #   => "verified"
  def verify!
    self.update_attribute(:status, VERIFIED)
  end

  # Permission Methods
  # ------------------

  def can_be_edited?
    pending?
  end

  def can_be_deleted?
    pending?
  end

  # Other Methods
  # -------------

  # * Return mobile number with dialling prefix
  # == Examples
  #   >>> registration.display_name
  #   => "+919880123456"
  def display_name
    "#{self.dialing_prefix} #{self.mobile_number}"
  end

  # * Return city, country or just country if there is no city
  # == Examples
  #   >>> registration.display_location
  #   => "Dubai, United Arab Emirates"
  def display_location
    [self.city.try(:name), self.country.try(:name)].compact.join(",")
  end
	
end