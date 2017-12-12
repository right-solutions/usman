class CorrectContacts < ActiveRecord::Migration[5.1]
  def change
  	add_column :contacts, :contact_number, :string, :null => false, :limit=>24
  	Usman::Contact.update_all("contact_number = contact_number_1")
  	remove_column :contacts, :contact_number_1
  end
end
