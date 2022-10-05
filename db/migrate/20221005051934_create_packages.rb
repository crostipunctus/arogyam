class CreatePackages < ActiveRecord::Migration[7.0]
  def change
    create_table :packages do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :duration

      t.timestamps
    end
  end
end
