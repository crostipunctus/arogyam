class AddUserAndBatchReferencesToRegistrations < ActiveRecord::Migration[7.0]
  def change
    add_reference :registrations, :user, null: false, foreign_key: true
    add_reference :registrations, :batch, null: false, foreign_key: true
  end
end
