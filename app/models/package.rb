class Package < ApplicationRecord
  DURATION_COSTS = {
    "ShamanaM" => {
      "7" => "41,000/-",
      "14" => "82,000/-"
    },
    "VishraM" => {
      "3" => "18,000",
      "5" => "30,000"
    }
  }.freeze

  has_rich_text :content
  has_rich_text :eligibility
  has_rich_text :note
  has_rich_text :benefits
  has_one_attached :package_image, dependent: :destroy do |attachable|
    attachable.variant :card, resize_to_limit: [600, 400],  saver: { quality: 80 }
    attachable.variant :hero, resize_to_limit: [1400, 900], saver: { quality: 82 }
  end
  has_many :registrations

  scope :published, -> { where(published: true) }
  
  validates :name, presence: true, uniqueness: true

  before_save :set_slug 

  def to_param
    slug
  end

  def self.formatted_cost(name:, cost: nil, duration: nil)
    amount = DURATION_COSTS.dig(name, duration.to_s) || cost
    "Rs. #{amount}" if amount.present?
  end

  def formatted_cost(duration: nil)
    self.class.formatted_cost(name: name, cost: cost, duration: duration)
  end

  private 

  def set_slug
    self.slug = name.parameterize
  end

end
