FactoryGirl.define do

  sequence(:email) {|n| "user.#{n}@domain.com" }
  sequence(:username) {|n| "username#{n}" }

  factory :user do

    name "First Middle Last"
    username
    email

    phone "123-456-7890"
    designation "My Designation"
    date_of_birth "01/01/1980"
    
    password_digest { SecureRandom.hex }
    password ConfigCenter::Defaults::PASSWORD
    password_confirmation ConfigCenter::Defaults::PASSWORD

    auth_token {SecureRandom.hex}
    token_created_at {Time.now}

    gender User::MALE

    dummy false

  end

  factory :pending_user, parent: :user do
    status "pending"
  end

  factory :approved_user, parent: :user do
    status "approved"
  end

  factory :suspended_user, parent: :user do
    status "suspended"
  end

  factory :super_admin_user, parent: :user do
    status "approved"
    super_admin true
  end

end
