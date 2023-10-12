# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    # Generates a random password with a minimum length of 8 characters
    password do
      Faker::Internet.password(min_length: 8)
    end
    password_confirmation { password }
  end
end
