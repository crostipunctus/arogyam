class AddColumnsToRegistrations < ActiveRecord::Migration[7.0]
  def change
    add_column :registrations, :completed, :boolean, default: false
    add_column :registrations, :comments, :text
  end
end
