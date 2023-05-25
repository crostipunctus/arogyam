class Registration < ApplicationRecord
  belongs_to :user 
  belongs_to :batch 
  belongs_to :package
  attr_accessor :agreement
  attr_accessor :terms

  after_create :registered
  after_create :not_cancelled
  before_destroy :send_cancel_email

  validates :lifestyle, :substances, :health_conditions, :medication, presence: true
  validates :agreement, acceptance: { accept: ["1", true], message: "must be accepted" }, on: :create
  validates :terms, acceptance: { accept: ["1", true], message: "must be accepted" }, on: :create

  
  private 

  

  def registered 
    self.status = "Registered"
  end 

  def not_cancelled 
    self.cancelled = false 
  end 
  
end
