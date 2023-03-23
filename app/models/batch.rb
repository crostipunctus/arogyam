class Batch < ApplicationRecord
  has_many :registrations, dependent: :destroy 
  has_many :users, through: :registrations
end
