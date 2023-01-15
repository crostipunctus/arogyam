class CreateTestimonials < ActiveRecord::Migration[7.0]
  def change
    create_table :testimonials do |t|
      t.string :title
      t.string :youtube_id

      t.timestamps
    end
  end
end
