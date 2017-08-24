class Device < ApplicationRecord
  
  # Constants
  EXCLUDED_JSON_ATTRIBUTES = [:last_accessed_at, :last_accessed_api, :otp, :otp_sent_at, :api_token, :token_created_at, :status, :created_at, :updated_at]

  PENDING = "pending"
  VERIFIED = "verified"
  BLOCKED = "blocked"
  
  STATUS = { 
    PENDING => "Pending", 
    VERIFIED => "Verified",
    BLOCKED => "Blocked"
  }

  STATUS_REVERSE = { 
    "Pending" => PENDING,
    "Verified" => VERIFIED,
    "Blocked" => BLOCKED
  }
  
	# Associations
  belongs_to :user, optional: true
  belongs_to :registration

  # Validations
  validates :uuid, presence: true, length: {maximum: 1024}
  validates :device_token, presence: true, length: {maximum: 1024}
  
  validates :device_name, allow_blank: true, length: {maximum: 64}
  validates :device_type, allow_blank: true, length: {maximum: 64}
  validates :operating_system, allow_blank: true, length: {maximum: 64}
  validates :software_version, allow_blank: true, length: {maximum: 64}
  validates :last_accessed_api, allow_blank: true, length: {maximum: 1024}

  validates :otp, allow_blank: true, length: {minimum: 5, maximum: 5}
  validates :api_token, allow_blank: true, length: {maximum: 256}

  validates :status, :presence => true, :inclusion => {:in => STATUS.keys, :presence_of => :status, :message => "%{value} is not a valid status" }

  # ------------------
  # Class Methods
  # ------------------

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> device.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| joins("INNER JOIN registrations on registrations.id = devices.registration_id
                                        LEFT JOIN users on users.id = devices.user_id").
                                 where("LOWER(devices.uuid) LIKE LOWER('%#{query}%') OR 
                                        LOWER(devices.device_token) LIKE LOWER('%#{query}%') OR 
                                        LOWER(devices.device_name) LIKE LOWER('%#{query}%') OR 
                                        LOWER(devices.device_type) LIKE LOWER('%#{query}%') OR 
                                        LOWER(registrations.mobile_number) LIKE LOWER('%#{query}%') OR 
                                        LOWER(users.name) LIKE LOWER('%#{query}%')")}
  scope :status, lambda { |status| where("LOWER(status)='#{status}'") }

  scope :pending, -> { where(status: PENDING) }
  scope :verified, -> { where(status: VERIFIED) }
  scope :blocked, -> { where(status: BLOCKED) }

  # ------------------
  # Instance Methods
  # ------------------

  # Exclude some attributes info from json output.
  def as_json(options={})
    options[:except] ||= EXCLUDED_JSON_ATTRIBUTES
    #options[:include] ||= []
    #options[:methods] = []
    #options[:methods] << :profile_image
    super(options)
  end
  
  # Status Methods
  # --------------

  # * Return true if the user is pending, else false.
  # == Examples
  #   >>> device.pending?
  #   => true
  def pending?
    (status == PENDING)
  end

  # * Return true if the user is not verified, else false.
  # == Examples
  #   >>> device.verified?
  #   => true
  def verified?
    (status == VERIFIED)
  end

  # * Return true if the user is not blocked, else false.
  # == Examples
  #   >>> device.blocked?
  #   => true
  def blocked?
    (status == BLOCKED)
  end

  # change the status to :pending
  # Return the status
  # == Examples
  #   >>> device.pending!
  #   => "pending"
  def pending!
    self.update_attribute(:status, PENDING)
  end

  # change the status to :verified
  # Return the status
  # == Examples
  #   >>> device.verify!
  #   => "verified"
  def verify!
    self.update_attribute(:status, VERIFIED)
  end

  # change the status to :blocked
  # Return the status
  # == Examples
  #   >>> device.block!
  #   => "blocked"
  def block!
    self.update_attribute(:status, BLOCKED)
  end

  # Permission Methods
  # ------------------

  def can_be_edited?
    false
  end

  def can_be_deleted?
    false
  end

  # Authentication Methods
  # ----------------------

  def generate_otp
    self.otp = rand(10000..99999)
  end

  # Other Methods
  # -------------

  # * Return full name
  # == Examples
  #   >>> device.display_mobile_number
  #   => "+919880123456"
  def display_name
    "#{self.device_name} - #{self.uuid}"
  end
	
end