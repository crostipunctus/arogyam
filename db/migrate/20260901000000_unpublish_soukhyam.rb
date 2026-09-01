class UnpublishSoukhyam < ActiveRecord::Migration[7.0]
  class MigrationPackage < ActiveRecord::Base
    self.table_name = "packages"
  end

  def up
    add_column :packages, :published, :boolean, default: true, null: false
    MigrationPackage.reset_column_information
    MigrationPackage.where(name: "SoukhyaM").update_all(published: false, updated_at: Time.current)
  end

  def down
    remove_column :packages, :published
  end
end
