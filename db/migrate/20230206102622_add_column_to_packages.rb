class AddColumnToPackages < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :duration, :string
  end
end
