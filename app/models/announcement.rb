class Announcement < ApplicationRecord
  validates :content, presence: true 
end
