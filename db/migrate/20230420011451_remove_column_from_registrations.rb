class RemoveColumnFromRegistrations < ActiveRecord::Migration[7.0]
  def change
    remove_column :registrations, :status, :string
  end
end
