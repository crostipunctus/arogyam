class AddDescriptionToPackage < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :description, :string
  end
end
