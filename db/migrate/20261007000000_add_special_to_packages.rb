class AddSpecialToPackages < ActiveRecord::Migration[8.1]
  def change
    add_column :packages, :special, :boolean, default: false, null: false
    add_index :packages, [:published, :special, :name]
  end
end
