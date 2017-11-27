FactoryGirl.define do

  factory :contact, class: Usman::Contact do
    
    association :done_deal_user, :factory => :user
    association :owner, :factory => :user
    association :device, :factory => :device

    name "Some Name"
    account_type "com.google"

    email "something@domain.com"
    address "Some Address"

    contact_number_1 "9912345678"
  end

end
