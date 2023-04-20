class AddStatusToVishraamRegistrations < ActiveRecord::Migration[7.0]
  def change
    add_column :vishraam_registrations, :status, :string
  end
end
