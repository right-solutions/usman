class AddOtpVerifiedAtToDevices < ActiveRecord::Migration[5.1]
  def change
    add_column :devices, :otp_verified_at, :datetime
  end
end
