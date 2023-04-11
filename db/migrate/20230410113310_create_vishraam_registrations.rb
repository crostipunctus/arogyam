class CreateVishraamRegistrations < ActiveRecord::Migration[7.0]
  def change
    create_table :vishraam_registrations do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.string :duration

      t.timestamps
    end
  end
end
