class AddSubtitleToBlogs < ActiveRecord::Migration[7.0]
  def change
    add_column :blogs, :subtitle, :string
  end
end
