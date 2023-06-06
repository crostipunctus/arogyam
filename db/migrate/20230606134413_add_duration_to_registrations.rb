class AddDurationToRegistrations < ActiveRecord::Migration[7.0]
  def change
    add_column :registrations, :duration, :string
  end
end
