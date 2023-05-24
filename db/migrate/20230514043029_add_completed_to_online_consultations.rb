class AddCompletedToOnlineConsultations < ActiveRecord::Migration[7.0]
  def change
    add_column :online_consultations, :completed, :boolean, default: false
  end
end
