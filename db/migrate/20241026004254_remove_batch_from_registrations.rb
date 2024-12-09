class RemoveBatchFromRegistrations < ActiveRecord::Migration[7.0]
  def change
    remove_reference :registrations, :batch, foreign_key: true
  end
end
