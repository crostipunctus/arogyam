class AddColumnsToVishraamRegistrations < ActiveRecord::Migration[7.0]
  def change
    add_column :vishraam_registrations, :comments, :text
    add_column :vishraam_registrations, :cancelled, :boolean, default: false
  end
end
