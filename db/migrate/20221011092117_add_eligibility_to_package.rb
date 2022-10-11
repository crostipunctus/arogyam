class AddEligibilityToPackage < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :eligibility, :text
  end
end
