class RemoveColumnFromVishraamRegistrations < ActiveRecord::Migration[7.0]
  def change
    remove_column :vishraam_registrations, :status, :string
  end
end
