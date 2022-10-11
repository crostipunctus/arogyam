class RemoveNoteFromPackage < ActiveRecord::Migration[7.0]
  def change
    remove_column :packages, :note, :text
  end
end
