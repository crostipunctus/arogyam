class AddColumnToRegistrations < ActiveRecord::Migration[7.0]
  def change
    add_column :registrations, :cancelled, :boolean
  end
end
