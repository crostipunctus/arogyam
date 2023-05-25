class AddCancelledToOnlineConsultations < ActiveRecord::Migration[7.0]
  def change
    add_column :online_consultations, :cancelled, :boolean
  end
end
