class CreateCaseSheets < ActiveRecord::Migration[7.0]
  def change
    create_table :case_sheets do |t|
      t.boolean :vegetarian
      t.string :height
      t.string :weight
      t.string :blood_group
      t.string :appetite
      t.string :sleep
      t.string :motion
      t.string :energy_level
      t.text :hereditary_mother
      t.text :hereditary_father
      t.text :surgeries
      t.string :normal_deliveries
      t.string :caesarian_deliveries
      t.text :exercise_routine
      t.text :past_ailments
      t.text :present_complaints

      t.references :online_consultation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
