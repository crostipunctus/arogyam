class DropContactDetailsTable < ActiveRecord::Migration[7.0]
    def up
      drop_table :contact_details
    end
  
    def down 
      raise ActiveRecord::IrreversibleMigration
    end 
end
