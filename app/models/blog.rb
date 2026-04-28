class Blog < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [400, 300], saver: { quality: 80 }
    attachable.variant :hero,  resize_to_limit: [1200, 800], saver: { quality: 82 }
  end
  has_rich_text :content 
  validates :title, presence: true
  validates :content, presence: true
end

