class RemoveConfirmedFromOnlineConsultations < ActiveRecord::Migration[7.0]
  def change
    remove_column :online_consultations, :confirmed, :boolean
  end
end
