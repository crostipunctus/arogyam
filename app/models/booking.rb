class Booking < ApplicationRecord
  validates :name, presence: true 
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
  validates :message, presence: true, length: { minimum: 10, maximum: 200}
end
