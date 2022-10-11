class AddNoteToPackage < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :note, :text
  end
end
