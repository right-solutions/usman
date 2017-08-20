class CreateOtpRegistrations < ActiveRecord::Migration[5.1]
  def change
    create_table :otp_registrations do |t|

      t.references :user, index: true
      t.references :country, index: true
      
      t.string :mobile_number
      
      t.integer :otp
      t.datetime :otp_sent_at
      t.string :status, :null => false, :default=>"pending", :limit=>16
      
      t.timestamps
    end
  end
end
