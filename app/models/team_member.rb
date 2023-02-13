class TeamMember < ApplicationRecord
  validates :name, presence: true
  validates :content, presence: true
  has_one_attached :avatar
end

