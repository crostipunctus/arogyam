class AddPackageToBookings < ActiveRecord::Migration[7.0]
  def change
    add_reference :bookings, :package
  end
end
