class AddStatusToOnlineConsultations < ActiveRecord::Migration[7.0]
  def change
    add_column :online_consultations, :status, :string
  end
end
