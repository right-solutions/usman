FactoryBot.define do

  factory :device do
    user
    registration

    uuid {SecureRandom.hex}
    device_token {SecureRandom.hex}
    device_name "Apple iPhone"
    device_type "iPhone 7 Plus"
    operating_system "iPhone 7 Plus"
    software_version "Apple iOS"
    
    last_accessed_at {Time.now}
    last_accessed_api "/api/v1/register"
  end

  factory :pending_device, parent: :device do
    status "pending"
  end

  factory :verified_device, parent: :device do
    status "verified"
    otp nil
    otp_sent_at { Time.now }
    otp_verified_at { Time.now }
  end

  factory :blocked_device, parent: :device do
    status "blocked"
  end

end
