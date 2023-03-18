class Registration < ApplicationRecord
  belongs_to :user 
  belongs_to :batch 

  
end
