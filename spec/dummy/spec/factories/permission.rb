FactoryBot.define do
  factory :permission do
    user
    feature

    can_create false
    can_read true
    can_update false
    can_delete false
  end

  factory :create_permission, parent: :permission do
    can_create true
  end

  factory :update_permission, parent: :permission do
    can_update true
  end

  factory :delete_permission, parent: :permission do
    can_delete true
  end

  factory :all_permission, parent: :permission do
    can_create true
    can_read true
    can_update true
    can_delete true
  end
end
