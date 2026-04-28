class TeamMember < ApplicationRecord
  validates :name, presence: true
  validates :content, presence: true
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [400, 400], saver: { quality: 82 }
  end
end

