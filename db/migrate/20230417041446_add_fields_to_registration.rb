class AddFieldsToRegistration < ActiveRecord::Migration[7.0]
  def change
    add_column :registrations, :substances, :text
    add_column :registrations, :lifestyle, :text
    add_column :registrations, :health_conditions, :text
    add_column :registrations, :medication, :text
  end
end
