require 'pattana/factories.rb'

FactoryBot.define do

  factory :registration do

    user
    country
    city

    dialing_prefix "+971"
    mobile_number "501122333"

    after :build do |reg|
      reg.country = reg.city.country if reg.city
    end

  end

  factory :pending_registration, parent: :registration do
    status "pending"
  end

  factory :verified_registration, parent: :registration do
    status "verified"
  end

  factory :suspended_registration, parent: :registration do
    status "suspended"
  end

end
