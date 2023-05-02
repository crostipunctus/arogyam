class AddAvailableToBookingDates < ActiveRecord::Migration[7.0]
  def change
    add_column :booking_dates, :available, :boolean
  end
end
