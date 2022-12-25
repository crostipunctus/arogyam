class Blog < ApplicationRecord
  belongs_to :user
  has_rich_text :title
  has_rich_text :content 

  validates :title, presence: true
  validates :content, presence: true, length: { minimum: 25 } 
end
