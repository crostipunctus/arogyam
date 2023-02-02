class AddDatesToPackages < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :dates, :string
  end
end
