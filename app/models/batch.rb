class Batch < ApplicationRecord
  has_many :registrations, dependent: :destroy 
  has_many :users, through: :registrations

  before_save :calculate_duration 

  private 

  def calculate_duration 
    self.duration = ((end_date - start_date) + 1).to_i
  end 

end
