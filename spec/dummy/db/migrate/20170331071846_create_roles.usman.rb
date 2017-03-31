# This migration comes from usman (originally 20140402113215)
class CreateRoles < ActiveRecord::Migration[5.0]
  
  def change
    create_table(:roles) do |t|
      t.string :name, limit: 256
      t.timestamps
    end

    create_table :roles_users do |t|
      t.belongs_to :user, index: true
      t.belongs_to :role, index: true
      t.timestamps
    end

    add_index(:roles_users, [ :user_id, :role_id ], :unique => true)
  end

end
