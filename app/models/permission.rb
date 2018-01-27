class Permission < Usman::ApplicationRecord
  
  # Associations
  belongs_to :user
  belongs_to :feature

  # Validations
  validates :can_create, inclusion: { in: [true, false] }
  validates :can_read, inclusion: { in: [true, false] }
  validates :can_update, inclusion: { in: [true, false] }
  validates :can_delete, inclusion: { in: [true, false] }

  # ------------------
  # Class Methods
  # ------------------

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> permission.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query|  joins("INNER JOIN users u on permissions.user_id = u.id").
                                  joins("INNER JOIN features f on permissions.feature_id = f.id").
                                  where("LOWER(u.name) LIKE LOWER('%#{query}%') OR\
                                        LOWER(u.username) LIKE LOWER('%#{query}%') OR\
                                        LOWER(u.email) LIKE LOWER('%#{query}%') OR\
                                        LOWER(f.name) LIKE LOWER('%#{query}%')")}


  def self.save_row_data(hsh)

    return if hsh[:user].blank? || hsh[:feature].blank?

    # Initializing error hash for displaying all errors altogether
    error_object = Kuppayam::Importer::ErrorHash.new

    user = User.find_by_username(hsh[:user].to_s.strip)
    unless user
      summary = "User '#{hsh[:user].to_s.strip}' doesn't exist"
      error_object.errors << { summary: summary }
      return error_object
    end

    feature = Feature.find_by_name(hsh[:feature].to_s.strip)
    
    unless feature
      summary = "Feature '#{hsh[:feature].to_s.strip}' doesn't exist"
      error_object.errors << { summary: summary }
      return error_object
    end

    permission = Permission.where("user_id = ? AND feature_id = ?", user.id, feature.id).first || Permission.new
    permission.user = user
    permission.feature = feature
    permission.can_create = hsh[:can_create].to_s.strip
    permission.can_read = hsh[:can_read].to_s.strip
    permission.can_update = hsh[:can_update].to_s.strip
    permission.can_delete = hsh[:can_delete].to_s.strip
    
    if permission.valid?
      begin
        permission.save!
      rescue Exception => e
        summary = "uncaught #{e} exception while handling connection: #{e.message}"
        details = "Stack trace: #{e.backtrace.map {|l| "  #{l}\n"}.join}"
        error_object.errors << { summary: summary, details: details }        
      end
    else
      summary = "Error while saving permission: #{user.name} - #{feature.name}"
      details = "Error! #{permission.errors.full_messages.to_sentence}"
      error_object.errors << { summary: summary, details: details }
    end
    return error_object
  end

  # Permission Methods
  # ------------------

  def can_be_deleted?
    true
  end

  def can_be_edited?
    true
  end

end