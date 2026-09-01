class Registration < ApplicationRecord
  SHAMANAM_DURATIONS = %w[7 14].freeze

  belongs_to :user 
  belongs_to :package
  attr_accessor :agreement
  attr_accessor :terms

  after_create :registered
  after_create :not_cancelled
 

  validates :lifestyle, :substances, :health_conditions, :medication, presence: true
  validates :agreement, acceptance: { accept: ["1", true], message: "must be accepted" }, on: :create
  validates :terms, acceptance: { accept: ["1", true], message: "must be accepted" }, on: :create
  validates :start_date, presence: true
  validate :package_must_be_published, on: :create
  validates :shamanam_duration,
            inclusion: { in: SHAMANAM_DURATIONS, message: "must be 7 or 14 days" },
            if: :shamanam?

  def selected_duration
    return shamanam_duration.presence || duration if shamanam?

    duration.presence || package&.duration
  end

  def programme_label
    return package&.name unless variable_duration_programme? && selected_duration.present?

    "#{package.name} — #{selected_duration} days"
  end

  def variable_duration_programme?
    vishraam? || shamanam?
  end

  def vishraam?
    package&.name == "VishraM"
  end

  def shamanam?
    package&.name == "ShamanaM"
  end
  
  private 

  def package_must_be_published
    errors.add(:package, "is no longer available") if package && !package.published?
  end

  

  def registered 
    self.status = "Registered"
  end 

  def not_cancelled 
    self.cancelled = false 
  end 
  
end
