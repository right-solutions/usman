class AddTacAcceptedAtToDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :tac_accepted_at, :datetime
  end
end
