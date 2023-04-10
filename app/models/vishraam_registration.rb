class VishraamRegistration < ApplicationRecord
  belongs_to :user

  validates :date, presence: true
  validates :duration, presence: true

  DURATION_OPTIONS = {
    '3 days' => 3,
    '5 days' => 5
  }
end
