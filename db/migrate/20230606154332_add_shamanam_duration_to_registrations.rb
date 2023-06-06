class AddShamanamDurationToRegistrations < ActiveRecord::Migration[7.0]
  def change
    add_column :registrations, :shamanam_duration, :string
  end
end
