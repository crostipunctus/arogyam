class AddShortDescriptionToPackages < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :short_description, :string
  end
end
