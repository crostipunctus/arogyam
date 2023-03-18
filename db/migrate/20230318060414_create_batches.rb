class CreateBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :batches do |t|
      t.date :start_date
      t.date :end_date
      t.string :duration

      t.timestamps
    end
  end
end
