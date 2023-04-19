class AddFieldsToVishraamRegistration < ActiveRecord::Migration[7.0]
  def change
    add_column :vishraam_registrations, :substances, :text
    add_column :vishraam_registrations, :lifestyle, :text
    add_column :vishraam_registrations, :health_conditions, :text
    add_column :vishraam_registrations, :medication, :text
  end
end
