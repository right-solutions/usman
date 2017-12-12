class Usman::Contact < Usman::ApplicationRecord
  
  # Set Table Name
  self.table_name = "contacts"

  # Associations
  belongs_to :owner, class_name: "User"
  belongs_to :done_deal_user, class_name: "User", optional: true
  belongs_to :registration, optional: true
  belongs_to :device, optional: true

  # Validations
  validates :name, presence: true, length: {maximum: 512}
  validates :account_type, length: {maximum: 256}

  validates :email, length: {maximum: 256}, allow_nil: true,
            format: /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i
  validates :address, length: {maximum: 512}

  validates :contact_number_1, presence: true, length: {maximum: 24}
  validates :contact_number_2, length: {maximum: 24}
  validates :contact_number_3, length: {maximum: 24}
  validates :contact_number_4, length: {maximum: 24}
  
  # ------------------
  # Class Methods
  # ------------------

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> Contact.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| where("LOWER(contacts.name) LIKE LOWER('%#{query}%') OR 
                                        LOWER(contacts.contact_number_1) LIKE LOWER('%#{query}%') OR 
                                        LOWER(contacts.contact_number_2) LIKE LOWER('%#{query}%') OR 
                                        LOWER(contacts.contact_number_3) LIKE LOWER('%#{query}%') OR 
                                        LOWER(contacts.contact_number_4) LIKE LOWER('%#{query}%') OR 
                                        LOWER(contacts.email) LIKE LOWER('%#{query}%') OR 
                                        LOWER(contacts.account_type) LIKE LOWER('%#{query}%')")}
  
  # ------------------
  # Instance Methods
  # ------------------

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

  # Other Methods
  # -------------

  # * Return full name
  # == Examples
  #   >>> contact.display_name
  #   => "<NAME>"
  def display_name
    "#{self.name}"
  end

  def get_done_deal_user
    arr = [self.contact_number_1, self.contact_number_2, self.contact_number_3, self.contact_number_4].compact.uniq
    return if arr.first.nil?
    reg = Registration.where("CONCAT_WS('', dialing_prefix, mobile_number) IN (?)", arr).first
    return reg && reg.user ? reg.user : nil
  end
	
end