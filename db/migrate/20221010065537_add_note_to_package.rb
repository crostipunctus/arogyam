class AddNoteToPackage < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :note, :string
  end
end
