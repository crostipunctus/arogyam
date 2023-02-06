class RemoveCostFromPackages < ActiveRecord::Migration[7.0]
  def change
    remove_column :packages, :cost, :decimal
  end
end
