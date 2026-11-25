class PublishMandalamWithWebsiteCopy < ActiveRecord::Migration[8.1]
  class MigrationPackage < ActiveRecord::Base
    self.table_name = "packages"
  end

  class MigrationRichText < ActiveRecord::Base
    self.table_name = "action_text_rich_texts"
  end

  IMAGE_PATH = Rails.root.join("db/data/mandalam-nasya-treatment.jpg")

  # The start date is flexible, so the programme has no published dates and
  # no fixed registration start date.
  ATTRIBUTES = {
    name: "MandalaM",
    slug: "mandalam",
    short_description: "A 48-day Ayurvedic wellness and lifestyle reset at Sacred Grove, with personalised treatments, daily yoga and meditation. Limited to 10 participants.",
    duration: "48",
    cost: "1,85,400",
    dates: nil,
    fixed_start_date: nil,
    published: true,
    special: true
  }.freeze

  CONTENT = <<~HTML
    <h2>Wellness and Lifestyle Reset Programme</h2>
    <p>MandalaM is a programme built around the traditional Ayurvedic approach to a therapeutic lifestyle reset over 48 days. Participants will follow a disciplined yet unhurried regimen designed around their individual needs, based on Ayurvedic principles.</p>
    <p>Upon registration, the participant will have an online consultation with our in-house Ayurveda doctor, who will be with them for the entire programme, to understand their health background, lifestyle, and wellbeing concerns. The participant will be asked to submit their health parameters report, and an individualised wellness and treatment plan will be prepared accordingly. The treatment start date remains flexible.</p>
    <p><strong>Highlights of the programme include:</strong></p>
    <ul>
      <li>Personalised and authentic Ayurvedic treatments</li>
      <li>Pure vegetarian Ayurvedic cuisine</li>
      <li>Daily Yoga, Yoga Nidra, and Meditation</li>
      <li>Lectures on Ayurveda and Ashtanga Yoga</li>
      <li>Dinacharya (daily routine) guidance</li>
      <li>A well-stocked library</li>
      <li>Nature walks</li>
    </ul>
    <h2>Experience Ayurvedic Dinacharya</h2>
    <p>A central part of the MandalaM experience is the opportunity to explore Dinacharya, the Ayurvedic concept of a daily routine. With guidance and support, participants can experience a structured daily rhythm that incorporates appropriate practices related to waking, personal care, food, activity, rest, yoga, meditation, and sleep.</p>
    <p>The intention is not simply to follow a schedule during the programme, but to understand how mindful daily habits can become part of one’s ongoing lifestyle.</p>
    <h2>Food</h2>
    <p>Participants will be provided with pure vegetarian food based on Ayurvedic principles, guided by our in-house physicians. Food and dietary practices will be customised according to individual requirements identified during the consultation.</p>
    <h2>Yoga &amp; Meditation</h2>
    <p>Daily guided sessions of Yoga Asanas and Yoga Nidra will be held. Participants will also have access to the Adwaita Meditation Hall, a dedicated space for silent meditation and contemplation.</p>
    <h2>Lectures on Ayurveda and Ashtanga Yoga</h2>
    <p>The programme also includes discussions on Ashtanga Yoga and Ayurveda, providing an opportunity to explore yoga not only as a physical practice but as a broader discipline of self-awareness and inner development.</p>
    <h2>Learning &amp; Reflection</h2>
    <p>The MandalaM programme combines practical experience with opportunities for self-reflection. Participants can spend time in the library, attend Ayurvedic lectures, participate in discussions, explore the teachings of Sri M, and walk through the natural surroundings.</p>
    <p>The programme intentionally includes free and unstructured time, without an unnecessarily rushed schedule.</p>
    <h2>Nature &amp; Goshala</h2>
    <p>The natural surroundings are an important part of any programme at ArogyaM. Participants will be taken on nature walks and hikes that offer time to slow down and be as close to nature as possible.</p>
    <p>Being in the presence of the cows, whose generosity keeps the kitchen going, is an experience in itself.</p>
    <h2>Group Size</h2>
    <p>To maintain a personal and supportive environment, the programme is limited to <strong>10 participants</strong>, and registration will close once all places are filled. This allows greater individual attention and closer interaction with the Vaidya and the programme team.</p>
    <h2>One-Day Temple Visit</h2>
    <p>Participants will have the opportunity to make a one-day visit to the Sriguru Babaji temple in Madanapalle.</p>
  HTML

  ELIGIBILITY = <<~HTML
    <p>Anyone between 18 and 75 years of age.</p>
  HTML

  NOTE = <<~HTML
    <ul>
      <li>Treatment won’t be administered to women on their special days.</li>
      <li>This is not a treatment for any illness, but a therapeutic programme.</li>
      <li>All programmes will be customised based on each care seeker’s health profile.</li>
      <li>The cost includes treatments, food, and accommodation (on a twin-sharing basis). Prescription medications aren’t included.</li>
      <li>Treatments may not be administered on all days of the programme.</li>
    </ul>
    <p>Further details will be shared after registration. For any queries, call <a href="tel:+918333981305">+91 83339 81305</a> or write to <a href="mailto:wellnesscenter@satsang-foundation.org">wellnesscenter@satsang-foundation.org</a>.</p>
  HTML

  # The highlights now sit in the introduction, so the separate benefits
  # section would only repeat them.
  RICH_TEXTS = { "content" => CONTENT, "eligibility" => ELIGIBILITY, "note" => NOTE }.freeze
  REMOVED_RICH_TEXTS = %w[benefits].freeze

  def up
    MigrationPackage.reset_column_information
    programme = MigrationPackage.find_by(slug: "mandalam")
    return unless programme

    programme.update!(ATTRIBUTES)
    replace_rich_texts(programme)
    replace_image(programme)
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Edit or unpublish MandalaM through the admin interface instead."
  end

  private

  def replace_rich_texts(programme)
    rich_texts = MigrationRichText.where(record_type: "Package", record_id: programme.id)
    rich_texts.where(name: REMOVED_RICH_TEXTS).delete_all

    RICH_TEXTS.each do |name, body|
      rich_texts.find_or_initialize_by(name: name).update!(body: body)
    end
  end

  # Mirrors uploading a new image in the admin form: the previous image, if
  # any, is purged. Analysing up front avoids depending on a background job.
  def replace_image(programme)
    attachment_scope = { record_type: "Package", record_id: programme.id, name: "package_image" }
    ActiveStorage::Attachment.where(attachment_scope).find_each(&:purge_later)

    blob = IMAGE_PATH.open("rb") do |file|
      ActiveStorage::Blob.create_and_upload!(io: file, filename: IMAGE_PATH.basename.to_s, content_type: "image/jpeg")
    end
    blob.analyze
    ActiveStorage::Attachment.create!(attachment_scope.merge(blob: blob))
  end
end
