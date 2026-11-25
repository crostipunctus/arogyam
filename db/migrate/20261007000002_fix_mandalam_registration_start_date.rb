class FixMandalamRegistrationStartDate < ActiveRecord::Migration[8.1]
  class MigrationPackage < ActiveRecord::Base
    self.table_name = "packages"
  end

  class MigrationRichText < ActiveRecord::Base
    self.table_name = "action_text_rich_texts"
  end

  TEXT_REPLACEMENTS = {
    "Participants may choose a starting date between <strong>12 and 17 January 2027</strong>, subject to programme arrangements." =>
      "All participants start on <strong>17 January 2027</strong>.",
    "Flexible arrival between <strong>12 and 17 January 2027</strong>, subject to programme arrangements." =>
      "The programme starts on <strong>17 January 2027</strong>."
  }.freeze

  def up
    add_column :packages, :fixed_start_date, :date
    set_mandalam_schedule
  end

  def set_mandalam_schedule
    MigrationPackage.reset_column_information
    MigrationPackage.where(slug: "mandalam").update_all(fixed_start_date: Date.new(2027, 1, 17))
    update_mandalam_text(TEXT_REPLACEMENTS)
  end

  def down
    update_mandalam_text(TEXT_REPLACEMENTS.invert)
    remove_column :packages, :fixed_start_date
  end

  private

  def update_mandalam_text(replacements)
    programme_ids = MigrationPackage.where(slug: "mandalam").select(:id)
    MigrationRichText.where(record_type: "Package", record_id: programme_ids, name: %w[content note]).find_each do |rich_text|
      body = replacements.reduce(rich_text.body) { |text, (old_text, new_text)| text.gsub(old_text, new_text) }
      rich_text.update!(body: body) if body != rich_text.body
    end
  end
end
