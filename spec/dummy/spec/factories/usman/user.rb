FactoryGirl.define do

  sequence(:email) {|n| "user.#{n}@domain.com" }
  sequence(:username) {|n| "username#{n}" }

  factory :user do

    name "First Middle Last"
    username
    email

    phone "123-456-7890"
    designation "My Designation"
    
    password_digest { SecureRandom.hex }
    password ConfigCenter::Defaults::PASSWORD
    password_confirmation ConfigCenter::Defaults::PASSWORD

    auth_token {SecureRandom.hex}
    token_created_at {Time.now}

  end

  factory :pending_user, parent: :user do
    status "pending"
  end

  factory :approved_user, parent: :user do
    status "approved"

    factory :site_admin_user do
      after(:create) do |user|
        user.add_role("Site Admin")
      end
    end

    factory :warehouse_manager do
      after(:create) do |user|
        user.add_role("Warehouse Manager")
      end
    end

    factory :pos_sales_manager do
      after(:create) do |user|
        user.add_role("POS Sales Manager")
      end
    end

    factory :pos_sales_staff do
      after(:create) do |user|
        user.add_role("POS Sales Staff")
      end
    end

  end

  factory :suspended_user, parent: :user do
    status "suspended"
  end

  factory :super_admin_user, parent: :user do
    status "approved"
    super_admin true
  end

end
