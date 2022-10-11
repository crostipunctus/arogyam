class RemoveDescriptionFromPackage < ActiveRecord::Migration[7.0]
  def change
    remove_column :packages, :description, :string
  end
end
