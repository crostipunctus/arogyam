class Package < ApplicationRecord

  has_rich_text :content
  has_rich_text :eligibility
  has_rich_text :note
  has_rich_text :benefits
  has_one_attached :package_image, dependent: :destroy
  has_many :registrations, dependent: :destroy
  
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
