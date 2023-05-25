class AddConfirmedToOnlineConsultations < ActiveRecord::Migration[7.0]
  def change
    add_column :online_consultations, :confirmed, :boolean, default: false
  end
end
