class AddStartDateToRegistrations < ActiveRecord::Migration[7.0]
  def change
    add_column :registrations, :start_date, :date
  end
end
