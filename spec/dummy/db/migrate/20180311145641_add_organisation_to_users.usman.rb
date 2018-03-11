# This migration comes from usman (originally 20180310082657)
class AddOrganisationToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :organisation, :string, :null => false, :limit=>128
  end
end
