class CaseSheet < ApplicationRecord
  belongs_to :online_consultation
  belongs_to :user
  validates :vegetarian, :height, :weight, :blood_group, :appetite, :sleep, :motion, :energy_level, :hereditary_mother, :hereditary_father, :surgeries, :normal_deliveries, :caesarian_deliveries, :exercise_routine, :past_ailments, :present_complaints, presence: true
end
