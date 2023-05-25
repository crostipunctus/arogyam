class AddReferencesToOnlineConsultations < ActiveRecord::Migration[7.0]
  def change
    add_reference :online_consultations, :booking_date, null: false, foreign_key: true
  end
end
