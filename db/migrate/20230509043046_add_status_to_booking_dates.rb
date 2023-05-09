class AddStatusToBookingDates < ActiveRecord::Migration[7.0]
  def change
    add_column :booking_dates, :status, :string
  end
end
