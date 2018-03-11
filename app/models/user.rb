class User < Usman::ApplicationRecord

  # including Password Methods
  has_secure_password

  # Constants
  PENDING = "pending"
  APPROVED = "approved"
  SUSPENDED = "suspended"
  DELETED = "deleted"
  
  STATUS = { 
    PENDING => "Pending", 
    APPROVED => "Approved", 
    SUSPENDED => "Suspended",
    DELETED => "Deleted"
  }

  STATUS_REVERSE = { 
    "Pending" => PENDING, 
    "Approved" => APPROVED, 
    "Suspended" => SUSPENDED,
    "Deleted" => DELETED
  }

  MALE = "male"
  FEMALE = "female"
  NOGENDER = "nogender"

  GENDER = { 
    MALE => "Male", 
    FEMALE => "Female", 
    NOGENDER => "No Gender"
  }

  GENDER_REVERSE = { 
    "Male" => MALE, 
    "Female" => FEMALE, 
    "No Gender" => NOGENDER
  }

  EXCLUDED_JSON_ATTRIBUTES = [:confirmation_token, :password_digest, :reset_password_token, :auth_token, :unlock_token, :status, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :failed_attempts, :locked_at, :created_at, :updated_at]
  DEFAULT_PASSWORD = "Password@1"
  SESSION_TIME_OUT = 120.minutes

  # Validations
  validates :name, presence: true, length: {minimum: 3, maximum: 250}
  validate_username :username
  validate_email :email
  validate_password :password, condition_method: :should_validate_password?

  validates :status, :presence => true, :inclusion => {:in => STATUS.keys, :presence_of => :status, :message => "%{value} is not a valid status" }
  validates :gender, :inclusion => {:in => GENDER.keys, :presence_of => :status, :message => "%{value} is not a valid gender" }, :allow_nil => true

  # Callbacks
  before_validation :generate_auth_token

  # Delegates
  delegate :mobile_number, :to => :registration, :prefix => true, :allow_nil => true
  delegate :dialing_prefix, :to => :registration, :prefix => true, :allow_nil => true

  # Associations
  has_one :profile_picture, :as => :imageable, :dependent => :destroy, :class_name => "Image::ProfilePicture"
  has_many :permissions
  has_many :features, through: :permissions
  has_many :devices
  has_one :registration
  has_many :contacts, class_name: "Usman::Contact", foreign_key: :owner_id
  has_and_belongs_to_many :roles
  belongs_to :country, optional: true
  belongs_to :city, optional: true

  
  # ------------------
  # Class Methods
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
  
  # Scopes Methods

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> user.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| where("LOWER(users.name) LIKE LOWER('%#{query}%') OR\
                                        LOWER(users.username) LIKE LOWER('%#{query}%') OR\
                                        LOWER(users.email) LIKE LOWER('%#{query}%') OR\
                                        LOWER(users.designation) LIKE LOWER('%#{query}%') OR\
                                        LOWER(users.organisation) LIKE LOWER('%#{query}%')")
                        }

  scope :status, lambda { |status| where("LOWER(status)='#{status}'") }

  scope :pending, -> { where(status: PENDING) }
  scope :approved, -> { where(status: APPROVED) }
  scope :suspended, -> { where(status: SUSPENDED) }
  scope :deleted, -> { where(status: DELETED) }
  
  scope :super_admins, -> { where(super_admin: TRUE) }
  scope :normal_users, -> { where(super_admin: FALSE) }

  # Need to write a scope so that we have one for showing only site admins
  # Also need to restrict the removal of site admin to super admin
  # scope :site_admins, -> { joins().where(super_admin: FALSE) }

  # Import Methods

  def self.save_row_data(hsh)

    return if hsh[:name].blank?

    user = User.find_by_username(hsh[:username]) || User.new
    user.name = hsh[:name]
    user.username = hsh[:username]
    user.designation = hsh[:designation]
    user.organisation = hsh[:organisation]
    user.email = hsh[:email]
    user.phone = hsh[:phone]

    user.super_admin = ["true", "t","1","yes","y"].include?(hsh[:super_admin].to_s.downcase.strip)

    user.status = hsh[:status]
    user.assign_default_password

    # Initializing error hash for displaying all errors altogether
    error_object = Kuppayam::Importer::ErrorHash.new

    if user.valid?
      begin
        user.save!
      rescue Exception => e
        summary = "uncaught #{e} exception while handling connection: #{e.message}"
        details = "Stack trace: #{e.backtrace.map {|l| "  #{l}\n"}.join}"
        error_object.errors << { summary: summary, details: details }        
      end
    else
      summary = "Error while saving user: #{user.name}"
      details = "Error! #{user.errors.full_messages.to_sentence}"
      error_object.errors << { summary: summary, details: details }
    end

    return error_object
  end

  # ------------------
  # Instance Methods
  # ------------------
  
  # Status Methods
  # --------------

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

  # * Return true if the user is deleted, else false.
  # == Examples
  #   >>> user.deleted?
  #   => true
  def deleted?
    (status == DELETED)
  end

  # change the status to :pending
  # Return the status
  # == Examples
  #   >>> user.pending!
  #   => "pending"
  def pending!
    self.update_attribute(:status, PENDING)
    self.registration.update_attribute(:status, PENDING) if self.registration
  end

  # change the status to :approved
  # Return the status
  # == Examples
  #   >>> user.approve!
  #   => "approved"
  def approve!
    self.update_attribute(:status, APPROVED)
    self.registration.update_attribute(:status, Registration::VERIFIED) if self.registration
  end

  # change the status to :suspended
  # Return the status
  # == Examples
  #   >>> user.suspend!
  #   => "suspended"
  def suspend!
    self.update_attribute(:status, SUSPENDED)
    self.registration.update_attribute(:status, SUSPENDED) if self.registration
  end

  # change the status to :deleted
  # Return the status
  # == Examples
  #   >>> user.delete!
  #   => "deleted"
  def delete!
    self.update_attribute(:status, DELETED)
    self.registration.update_attribute(:status, DELETED) if self.registration
  end

  # Gender Methods
  # --------------

  # * Return true if the user is male, else false.
  # == Examples
  #   >>> user.male?
  #   => true
  def male?
    (gender == MALE)
  end

  # * Return true if the user is female, else false.
  # == Examples
  #   >>> user.female?
  #   => true
  def female?
    (gender == FEMALE)
  end

  # * Return true if the user is nogender, else false.
  # == Examples
  #   >>> user.nogender?
  #   => true
  def nogender?
    (gender == NOGENDER)
  end

  # Authentication Methods
  # ----------------------

  def start_session(remote_ip)
    self.current_sign_in_at = Time.now
    self.current_sign_in_ip = remote_ip

    self.sign_in_count = self.sign_in_count ? self.sign_in_count + 1 : 1

    self.save
  end

  def end_session
    self.last_sign_in_at = self.current_sign_in_at
    self.last_sign_in_ip = self.current_sign_in_ip
    
    self.current_sign_in_at = nil
    self.current_sign_in_ip = nil

    self.save
  end

  def assign_default_password
    self.password = DEFAULT_PASSWORD
    self.password_confirmation = DEFAULT_PASSWORD
  end

  def generate_reset_password_token
     self.reset_password_token = SecureRandom.hex unless self.reset_password_token
     self.reset_password_sent_at = Time.now unless self.reset_password_sent_at
  end

  # Permission Methods
  # ------------------

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

  def can_be_approved?
    pending? or suspended?
  end

  def can_be_marked_as_pending?
    approved? or suspended?
  end

  def can_be_suspended?
    approved? or pending?
  end

  def can_be_deleted?
    suspended?
  end

  def can_be_edited?
    !suspended?
  end

  # Role Methods
  # ------------

  def add_role(role)
    return false unless self.approved?
    role = Role.find_by_name(role) if role.is_a?(String)
    if role
      self.roles << role unless self.has_role?(role)
      return true
    else
      return false
    end
  end

  def remove_role(role)
    role = Role.find_by_name(role) if role.is_a?(String)
    self.roles.delete(role) if role
  end

  def has_role?(role)
    role = Role.find_by_name(role) if role.is_a?(String)
    if role && role.persisted?
      return true if self.super_admin
      self.roles.exists?(:id => [role.id])
    else
      return false
    end
  end

  # Permission Methods
  # ------------------

  def add_permission(feature_name, **options)
    options.reverse_merge!(
      can_create: false,
      can_read: true,
      can_update: false,
      can_delete: false
    )
    feature = Feature.find_by_name(feature_name)
    permission = self.permissions.where("feature_id = ?", feature.id).first || self.permissions.build
    permission.feature = feature
    permission.can_create = options[:can_create]
    permission.can_read = options[:can_read]
    permission.can_update = options[:can_update]
    permission.can_delete = options[:can_delete]
    permission.save
    permission
  end

  def has_read_permission?(class_name)
    return true if self.super_admin?
    feature = Feature.published.find_by_name(class_name.to_s)
    if feature
      permission = self.permissions.where("feature_id =?", feature.id).first
      return permission && permission.can_read?
    else
      return false
    end
  end

  def has_create_permission?(class_name)
    return true if self.super_admin?
    feature = Feature.published.find_by_name(class_name.to_s)
    if feature
      permission = self.permissions.where("feature_id =?", feature.id).first
      return permission && permission.can_create?
    else
      return false
    end
  end

  def has_update_permission?(class_name)
    return true if self.super_admin?
    feature = Feature.published.find_by_name(class_name.to_s)
    if feature
      permission = self.permissions.where("feature_id =?", feature.id).first
      return permission && permission.can_update?
    else
      return false
    end
  end

  def has_delete_permission?(class_name)
    return true if self.super_admin?
    feature = Feature.published.find_by_name(class_name.to_s)
    if feature
      permission = self.permissions.where("feature_id =?", feature.id).first
      return permission && permission.can_delete?
    else
      return false
    end
  end

  # Other Methods
  # -------------

  # * Return full name
  # == Examples
  #   >>> user.display_name
  #   => "Joe Black"
  def display_name
    "#{name}"
  end

  def default_image_url(size="small")
    "kuppayam/defaults/user-#{size}.png"
  end

  def generate_username_and_password
    self.username = SecureRandom.hex(4) unless self.username
    # Password should contain at least one special character, integer and one upper case character
    passwd = SecureRandom.hex(8) + "A@1" unless self.password
    self.password = passwd
    self.password_confirmation = passwd
  end

  def generate_dummy_data(registration)
    generate_username_and_password
    self.email = "#{self.username}@donedealapps.com"
    self.name = "User #{registration.try(:id)}"
    self.country_id = registration.country_id
    self.city_id = registration.city_id
    self.dummy = true
  end

  # Image Configuration
  # -------------------
  def image_configuration
    {
      "Image::ProfilePicture" => {
        max_upload_limit: 10485760,
        min_upload_limit: 1024,
        resolutions: [400, 400],
        form_upload_image_label: "Upload a new Image",
        form_title: "Upload an Image (Profile)",
        form_sub_title: "Please read the instructions below:",
        form_instructions: [
          "the filename should be in .jpg / .jpeg or .png format",
          "the image resolutions should be <strong>400 x 400 Pixels</strong>",
          "the file size should be greater than 100 Kb and or lesser than <strong>10 MB</strong>"
        ]
      }
    }
  end

  private

  def should_validate_password?
    self.new_record? || (self.new_record? == false and self.password_digest_changed?)
  end

  def generate_auth_token
    self.auth_token = SecureRandom.hex unless self.auth_token
  end

  # FIXME - this should be either removed or moved to feature model
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

  def self.find_by_email_or_username(query)
    self.where("LOWER(email) = LOWER('#{query}') OR LOWER(username) = LOWER('#{query}')").first
  end

end
