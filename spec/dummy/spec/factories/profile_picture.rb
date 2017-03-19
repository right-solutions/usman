FactoryGirl.define do
  factory :picture, :class => Image::Base do
    image { Rack::Test::UploadedFile.new('spec/factories/test.jpg', 'image/jpg') }
  end

  factory :user_picture, parent: :picture do
    association :imageable, :factory => :user
  end
end
