class CreateTeamMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :team_members do |t|
      t.string :name
      t.text :content
      t.string :role

      t.timestamps
    end
  end
end
