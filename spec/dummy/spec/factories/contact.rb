FactoryGirl.define do

  factory :contact, class: Usman::Contact do
    
    association :done_deal_user, :factory => :user
    association :owner, :factory => :user
    association :device, :factory => :device

    name "Some Name"
    account_type "com.google"

    contact_number "9912345678"
  end

end
