class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :blogs, dependent: :destroy
  has_many :registrations, dependent: :destroy 
  has_many :batches, through: :registrations
  has_many :vishraam_registrations, dependent: :destroy

  has_one :user_profile, dependent: :destroy

  # check if profile associated with the user has been created. 

end
