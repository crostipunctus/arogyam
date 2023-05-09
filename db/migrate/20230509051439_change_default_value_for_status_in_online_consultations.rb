class ChangeDefaultValueForStatusInOnlineConsultations < ActiveRecord::Migration[7.0]
  def change
    change_column_default :online_consultations, :status, "unconfirmed"
  end
end
