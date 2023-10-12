# frozen_string_literal: true

FactoryBot.define do
  factory :image do
    name { Faker::Lorem.word }
    file { Rack::Test::UploadedFile.new('spec/factories/images/test_image.jpg', 'image/jpg') }
    description { Faker::Lorem.sentence }
  end
end
