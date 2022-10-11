class RemoveEligibilityFromPackage < ActiveRecord::Migration[7.0]
  def change
    remove_column :packages, :eligibility, :text
  end
end
