class CreateSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :settings do |t|
      t.string :whatsapp_number
      t.string :whatsapp_message

      t.timestamps
    end
  end
end
