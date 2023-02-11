class DropContactsTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :contacts
  end

  def down 
    raise ActiveRecord::IrreversibleMigration
  end 
end
