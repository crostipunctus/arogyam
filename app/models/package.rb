class Package < ApplicationRecord

  has_rich_text :content
  has_rich_text :eligibility
  has_rich_text :note
  has_rich_text :benefits
  has_one_attached :package_image, dependent: :destroy do |attachable|
    attachable.variant :card, resize_to_limit: [600, 400],  saver: { quality: 80 }
    attachable.variant :hero, resize_to_limit: [1400, 900], saver: { quality: 82 }
  end
  has_many :registrations
  
  validates :name, presence: true, uniqueness: true

  before_save :set_slug 

  def to_param
    slug
  end

  private 

  def set_slug
    self.slug = name.parameterize
  end

end
