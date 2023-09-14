class Blog < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end
  has_rich_text :content 
  validates :title, presence: true
  validates :content, presence: true
end

