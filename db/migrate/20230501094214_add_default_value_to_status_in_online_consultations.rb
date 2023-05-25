class AddDefaultValueToStatusInOnlineConsultations < ActiveRecord::Migration[7.0]
  def up
    change_column :online_consultations, :status, :string, default: 'case sheet pending'
  end

  def down
    change_column :online_consultations, :status, :string, default: nil
  end
end
