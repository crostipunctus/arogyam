class Package < ApplicationRecord

  has_rich_text :content
  has_rich_text :eligibility
  has_rich_text :note
  has_rich_text :benefits
  has_one_attached :package_image
  has_many :bookings 


  validates :name, presence: true
end
