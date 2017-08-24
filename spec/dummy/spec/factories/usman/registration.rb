require 'pattana/factories.rb'

FactoryGirl.define do

  factory :registration do

    user
    country
    city

    dialing_prefix "+971"
    mobile_number "501122333"

  end

  factory :pending_registration, parent: :registration do
    status "pending"
  end

  factory :verified_registration, parent: :registration do
    status "verified"
  end

end
