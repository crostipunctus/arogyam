class AddColumnToVishraamRegistrations < ActiveRecord::Migration[7.0]
  def change
    add_column :vishraam_registrations, :completed, :boolean, default: false
  end
end
