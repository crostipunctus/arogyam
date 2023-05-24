class AddDefaultValueToCancelledInOnlineConsultations < ActiveRecord::Migration[7.0]
  def up
    change_column :online_consultations, :cancelled, :boolean, default: false
  end

  def down
    change_column :online_consultations, :cancelled, :boolean, default: nil
  end
end
