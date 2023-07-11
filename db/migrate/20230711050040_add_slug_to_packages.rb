class AddSlugToPackages < ActiveRecord::Migration[7.0]
  def change
    add_column :packages, :slug, :string
  end
end
