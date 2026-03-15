class DropOnlineConsultationTables < ActiveRecord::Migration[7.0]
  def up
    drop_table :case_sheets, if_exists: true
    drop_table :online_consultations, if_exists: true
    drop_table :booking_dates, if_exists: true
  end

  def down
    create_table :booking_dates do |t|
      t.date :date
      t.string :start_time
      t.string :end_time
      t.boolean :available, default: true
      t.string :status, default: "available"
      t.timestamps
    end

    create_table :online_consultations do |t|
      t.date :date
      t.string :start_time
      t.string :end_time
      t.references :user, foreign_key: true
      t.references :booking_date, foreign_key: true
      t.string :duration
      t.string :status, default: "unconfirmed"
      t.boolean :confirmed, default: false
      t.boolean :cancelled, default: false
      t.boolean :completed, default: false
      t.boolean :payment_complete, default: false
      t.timestamps
    end

    create_table :case_sheets do |t|
      t.references :online_consultation, foreign_key: true
      t.references :user, foreign_key: true
      t.string :vegetarian
      t.string :height
      t.string :weight
      t.string :blood_group
      t.string :appetite
      t.string :sleep
      t.string :motion
      t.string :energy_level
      t.string :hereditary_mother
      t.string :hereditary_father
      t.string :surgeries
      t.string :normal_deliveries
      t.string :caesarian_deliveries
      t.string :exercise_routine
      t.text :past_ailments
      t.text :present_complaints
      t.boolean :confirmed, default: false
      t.timestamps
    end
  end
end
