class User < ActiveRecord::Base

  extend KuppayamValidators
  
  # including Password Methods
  has_secure_password

  # Constants
  PENDING = "pending"
  APPROVED = "approved"
  SUSPENDED = "suspended"
  
  STATUS = { 
    PENDING => "Pending", 
    APPROVED => "Approved", 
    SUSPENDED => "Suspended"
  }

  STATUS_REVERSE = { 
    "Pending" => PENDING, 
    "Approved" => APPROVED, 
    "Suspended" => SUSPENDED
  }

  EXCLUDED_JSON_ATTRIBUTES = [:confirmation_token, :password_digest, :reset_password_token, :unlock_token, :status, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :failed_attempts, :locked_at, :created_at, :updated_at]
  DEFAULT_PASSWORD = "Password@1"
  SESSION_TIME_OUT = 30.minutes

  # Validations
  validate_string :name, mandatory: true
  validate_username :username
  validate_email :email
  validate_password :password, condition_method: :should_validate_password?

  validates :status, :presence => true, :inclusion => {:in => STATUS.keys, :presence_of => :status, :message => "%{value} is not a valid status" }

  # Callbacks
  before_validation :generate_auth_token

  # Associations
  has_one :profile_picture, :as => :imageable, :dependent => :destroy, :class_name => "Image::ProfilePicture"
  has_many :permissions
  has_many :features, through: :permissions

  
  # ------------------
  # Class Methods
  # ------------------

  def self.find_by_email_or_username(query)
    self.where("LOWER(email) = LOWER('#{query}') OR LOWER(username) = LOWER('#{query}')").first
  end

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> user.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| where("LOWER(name) LIKE LOWER('%#{query}%') OR\
                                        LOWER(username) LIKE LOWER('%#{query}%') OR\
                                        LOWER(email) LIKE LOWER('%#{query}%') OR\
                                        LOWER(designation) LIKE LOWER('%#{query}%')")
                        }

  scope :status, lambda { |status| where("LOWER(status)='#{status}'") }

  scope :pending, -> { where(status: PENDING) }
  scope :approved, -> { where(status: APPROVED) }
  scope :suspended, -> { where(status: SUSPENDED) }

  # ------------------
  # Instance variables
  # ------------------

  # * Return full name
  # == Examples
  #   >>> user.display_name
  #   => "Joe Black"
  def display_name
    "#{name}"
  end

  # * Return true if the user is not approved, else false.
  # == Examples
  #   >>> user.approved?
  #   => true
  def approved?
    (status == APPROVED)
  end

  # * Return true if the user is pending, else false.
  # == Examples
  #   >>> user.pending?
  #   => true
  def pending?
    (status == PENDING)
  end

  # * Return true if the user is suspended, else false.
  # == Examples
  #   >>> user.suspended?
  #   => true
  def suspended?
    (status == SUSPENDED)
  end

  # change the status to :pending
  # Return the status
  # == Examples
  #   >>> user.pending!
  #   => "pending"
  def pending!
    self.update_attribute(:status, PENDING)
  end

  # change the status to :approved
  # Return the status
  # == Examples
  #   >>> user.approve!
  #   => "approved"
  def approve!
    self.update_attribute(:status, APPROVED)
  end

  # change the status to :suspended
  # Return the status
  # == Examples
  #   >>> user.suspend!
  #   => "suspended"
  def suspend!
    self.update_attribute(:status, SUSPENDED)
  end

  def is_super_admin?
    super_admin
  end

  def start_session
    # FIX ME - specs are not written to ensure that all these data are saved
    self.token_created_at = Time.now
    self.sign_in_count = self.sign_in_count ? self.sign_in_count + 1 : 1
    self.last_sign_in_at = self.current_sign_in_at
    self.last_sign_in_ip = self.current_sign_in_ip
    self.current_sign_in_at = self.token_created_at

    # FIX ME - pass remote_ip to this method.
    # Make necessary changes to authentication service to make it work
    # self.current_sign_in_ip = remote_ip if remote_ip
    self.save
  end

  def end_session
    # Reseting the auth token for user when he logs out.
    # (Time.now - 1.second)
    self.update_attributes auth_token: SecureRandom.hex, token_created_at: nil
  end

  def assign_default_password
    self.password = DEFAULT_PASSWORD
    self.password_confirmation = DEFAULT_PASSWORD
  end

  def token_expired?
    return self.token_created_at.nil? || (Time.now > self.token_created_at + SESSION_TIME_OUT)
  end

  def generate_reset_password_token
     self.reset_password_token = SecureRandom.hex unless self.reset_password_token
     self.reset_password_sent_at = Time.now unless self.reset_password_sent_at
  end

  def default_image_url(size="small")
    "/assets/kuppayam/defaults/user-#{size}.png"
  end

  def set_permission(feature_name, **options)
    options.reverse_merge!(
      can_create: false,
      can_read: true,
      can_update: false,
      can_delete: false
    )

    feature = get_feature(feature_name)

    permission = Permission.where("user_id = ? AND feature_id = ?", self.id, feature.id).first || Permission.new(user: self, feature: feature)
    permission.assign_attributes(options)
    permission.save
  end

  def can_create?(feature_name)
    feature = get_feature(feature_name)

    permission = Permission.where("feature_id = ? AND user_id = ?", feature.id, self.id).first
    permission && permission.can_create?
  end

  def can_read?(feature_name)
    feature = get_feature(feature_name)

    permission = Permission.where("feature_id = ? AND user_id = ?", feature.id, self.id).first
    permission && permission.can_read?
  end

  def can_update?(feature_name)
    feature = get_feature(feature_name)

    permission = Permission.where("feature_id = ? AND user_id = ?", feature.id, self.id).first
    permission && permission.can_update?
  end

  def can_delete?(feature_name)
    feature = get_feature(feature_name)

    permission = Permission.where("feature_id = ? AND user_id = ?", feature.id, self.id).first
    permission && permission.can_delete?
  end

  def can_be_destroyed?
    return true
  end

  private

  def should_validate_password?
    self.new_record? || (self.new_record? == false and self.password.present?)
  end

  def generate_auth_token
    self.auth_token = SecureRandom.hex unless self.auth_token
  end

  def get_feature(feature_name)
    case feature_name
    when Feature
      feature = feature_name
    when String
      feature = Feature.find_by_name(feature_name)
    when Integer
      feature = Feature.find_by_id(feature_name)
    else
      raise "Feature with name '#{feature.name}' doesn't exist" unless feature
    end
    return feature
  end

end
