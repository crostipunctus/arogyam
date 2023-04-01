class UserProfile < ApplicationRecord
  belongs_to :user
  validates :gender, :date_of_birth, :address, :city, :zip, :country, :phone_number, :nationality, :occupation, presence: true
end
