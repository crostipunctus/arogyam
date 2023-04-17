class AddPackageReferencesToRegistrations < ActiveRecord::Migration[7.0]
  def change
    add_reference :registrations, :package, foreign_key: true
  end
end
