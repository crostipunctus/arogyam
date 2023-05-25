class RemoveNameEmailPhoneFromRegistrations < ActiveRecord::Migration[7.0]
  def change
    remove_column :registrations, :name, :string
    remove_column :registrations, :email, :string
    remove_column :registrations, :phone, :string
  end
end
