class Permission < ApplicationRecord
  
  require 'import_error_handler.rb'
  extend Usman::ImportErrorHandler

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


  def self.save_row_data(row, base_path)

    image_base_path = base_path + "images/"

    row.headers.each{ |cell| row[cell] = row[cell].to_s.strip }

    return if row[:user].blank? || row[:feature].blank?

    # Initializing error hash for displaying all errors altogether
    error_object = Usman::ErrorHash.new

    user = User.find_by_username(row[:user])
    unless user
      summary = "User '#{row[:user]}' doesn't exist"
      error_object.errors << { summary: summary }
      return error_object
    end

    feature = Feature.find_by_name(row[:feature])
    unless feature
      summary = "Feature '#{row[:feature]}' doesn't exist"
      error_object.errors << { summary: summary }
      return error_object
    end

    permission = Permission.where("user_id = ? AND feature_id = ?", user.id, feature.id).first || Permission.new
    permission.user = user
    permission.feature = feature
    permission.can_create = row[:can_create]
    permission.can_read = row[:can_read]
    permission.can_update = row[:can_update]
    permission.can_delete = row[:can_delete]
    
    if permission.valid?
      permission.save!
    else
      summary = "Error while saving permission: #{user.name} - #{feature.name}"
      details = "Error! #{permission.errors.full_messages.to_sentence}"
      error_object.errors << { summary: summary, details: details }
    end
    return error_object
  end

end