class AddDurationToOnlineConsultations < ActiveRecord::Migration[7.0]
  def change
    add_column :online_consultations, :duration, :string
  end
end
