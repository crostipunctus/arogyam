class RemoveColumnFromPackages < ActiveRecord::Migration[7.0]
  def change
    remove_column :packages, :duration, :integer
  end
end
