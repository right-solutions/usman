FactoryBot.define do
  factory :profile_picture, :class => Image::ProfilePicture do
    image { Rack::Test::UploadedFile.new('spec/dummy/spec/factories/test.jpeg', 'image/jpg') }
    association :imageable, :factory => :user
  end
end
