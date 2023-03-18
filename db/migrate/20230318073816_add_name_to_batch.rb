class AddNameToBatch < ActiveRecord::Migration[7.0]
  def change
    add_column :batches, :name, :string
  end
end
