class Batch < ApplicationRecord
  has_many :users, through: :registrations

  

  

  
end
