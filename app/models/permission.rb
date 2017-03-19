class Permission < ApplicationRecord
  
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
end