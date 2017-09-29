class AddDummyToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :dummy, :boolean, default: false
  end
end
