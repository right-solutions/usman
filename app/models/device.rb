class Device < ApplicationRecord
  
  # Constants
  EXCLUDED_JSON_ATTRIBUTES = [:last_accessed_at, :last_accessed_api, :otp, :otp_sent_at, :api_token, :token_created_at, :tac_accepted_at, :created_at, :updated_at]

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
    #options[:methods] = []
    #options[:methods] << :api_token
    json = super(options)
    Hash[*json.map{|k, v| [k, v || ""]}.flatten]
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
    self.otp_sent_at = nil
    self.otp_verified_at = nil
    self.save
  end

  def validate_otp(otp, dialing_prefix, mobile_number)

    # Validate OTP and other parameters
    validation_errors = {}

    # TODO - remove 11111 after implementing Twilio
    validation_errors[:otp] = "doesn't match with our database" unless (self.otp.to_s == otp.to_s or otp.to_s == "11111")
    validation_errors[:mobile_number] = "doesn't match with our database" unless self.registration.mobile_number.to_s == mobile_number.to_s
    validation_errors[:dialing_prefix] = "doesn't match with our database" unless self.registration.dialing_prefix.to_s == dialing_prefix.to_s
    
    return false, validation_errors unless validation_errors.empty?
    
    # Create API Token if OTP is verified
    self.otp_verified_at = Time.now
    self.api_token = SecureRandom.hex
    self.token_created_at = Time.now
    self.save

    self.verify!
    
    # Clearing the OTP so that next time if he uses the same, it shows error
    self.otp = nil
    self.save

    return true, {}
  end

  def resend_otp(dialing_prefix, mobile_number)
    # Validate OTP and other parameters
    validation_errors = {}

    validation_errors[:mobile_number] = "doesn't match with our database" unless self.registration.mobile_number.to_s == mobile_number.to_s
    validation_errors[:dialing_prefix] = "doesn't match with our database" unless self.registration.dialing_prefix.to_s == dialing_prefix.to_s
    
    return false, validation_errors unless validation_errors.empty?
    
    self.send_otp

    return true, {}
  end

  def send_otp
    self.generate_otp
    return true
  end

  def accept_tac(tac, dialing_prefix, mobile_number)

    # Validate OTP and other parameters
    validation_errors = {}

    # Check if terms and conditions was accepted
    unless ["true", "yes", "t", "y", "1"].include?(tac.to_s.downcase)
      validation_errors[:terms_and_conditions] = "must be true"
      return false, validation_errors
    end

    validation_errors[:mobile_number] = "doesn't match with our database" unless self.registration.mobile_number.to_s == mobile_number.to_s
    validation_errors[:dialing_prefix] = "doesn't match with our database" unless self.registration.dialing_prefix.to_s == dialing_prefix.to_s
    
    return false, validation_errors unless validation_errors.empty?
    
    # Create API Token if OTP is verified
    self.tac_accepted_at = Time.now
    self.save

    # Verify the Registration as it is now complete
    self.registration.verify!

    # Approve the user if it not already approved
    self.registration.user.approve! if self.registration.user

    return true, {}
  end

  def tac_accepted?
    self.tac_accepted_at.present? && self.tac_accepted_at < Time.now
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