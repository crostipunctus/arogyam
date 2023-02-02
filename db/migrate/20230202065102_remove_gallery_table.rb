class RemoveGalleryTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :galleries
  end
end
