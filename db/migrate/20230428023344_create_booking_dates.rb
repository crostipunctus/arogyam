class CreateBookingDates < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_dates do |t|
      t.date :date
      t.string :start_time
      t.string :end_time

      t.timestamps
    end
  end
end
