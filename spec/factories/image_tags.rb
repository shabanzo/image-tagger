# frozen_string_literal: true

FactoryBot.define do
  factory :image_tag do
    association :image, factory: :image
    association :tag, factory: :tag
    probability { 9.5 }
  end
end
