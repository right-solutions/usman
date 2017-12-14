FactoryBot.define do

  factory :feature do
    name "Feature Name"
    categorisable false
  end

  factory :published_feature, parent: :feature do
    status "published"
  end

  factory :unpublished_feature, parent: :feature do
    status "unpublished"
  end

  factory :removed_feature, parent: :feature do
    status "removed"
  end
  
end
