class Booking < ApplicationRecord
  validates :name, presence: true 
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
  validates :message, length: { maximum: 200}

  belongs_to :package
end
