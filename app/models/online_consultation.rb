class OnlineConsultation < ApplicationRecord
  belongs_to :user
  has_one :case_sheet, dependent: :destroy
end 