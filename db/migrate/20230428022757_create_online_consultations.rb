class CreateOnlineConsultations < ActiveRecord::Migration[7.0]
  def change
    create_table :online_consultations do |t|
      t.date :date
      t.string :start_time
      t.string :end_time
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
