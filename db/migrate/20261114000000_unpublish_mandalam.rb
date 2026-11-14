class UnpublishMandalam < ActiveRecord::Migration[8.1]
  class MigrationPackage < ActiveRecord::Base
    self.table_name = "packages"
  end

  def up
    set_mandalam_published(false)
  end

  def down
    set_mandalam_published(true)
  end

  private

  def set_mandalam_published(published)
    MigrationPackage.where(slug: "mandalam").update_all(published: published, updated_at: Time.current)
  end
end
