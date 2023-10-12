class Image < ApplicationRecord
  has_one_attached :file

  validates :name, presence: true

  has_many :image_tags, dependent: :destroy
  has_many :tags, through: :image_tags
end
