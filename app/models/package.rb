class Package < ApplicationRecord

  has_rich_text :content
  has_rich_text :eligibility
  has_rich_text :note
  has_one_attached :package_image

  validates :name, presence: true
end
