class AddFieldsToUserProfile < ActiveRecord::Migration[7.0]
  def change
    add_column :user_profiles, :gender, :string
    add_column :user_profiles, :date_of_birth, :date
    add_column :user_profiles, :address, :string
    add_column :user_profiles, :city, :string
    add_column :user_profiles, :zip, :string
    add_column :user_profiles, :country, :string
    add_column :user_profiles, :phone_number, :string
    add_column :user_profiles, :alternate_phone_number, :string
    add_column :user_profiles, :doctor_contact_details, :string
    add_column :user_profiles, :nationality, :string
    add_column :user_profiles, :marital_status, :string
    add_column :user_profiles, :occupation, :string
  end
end
