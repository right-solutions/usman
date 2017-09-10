FactoryGirl.define do

  factory :feature do
    name "Feature Name"
  end

  factory :published_feature, parent: :feature do
    status "published"
  end

  factory :unpublished_feature, parent: :feature do
    status "unpublished"
  end

  factory :disabled_feature, parent: :feature do
    status "disabled"
  end
  
end
