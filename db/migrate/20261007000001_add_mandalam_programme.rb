class AddMandalamProgramme < ActiveRecord::Migration[8.1]
  class MigrationPackage < ActiveRecord::Base
    self.table_name = "packages"
  end

  class MigrationRichText < ActiveRecord::Base
    self.table_name = "action_text_rich_texts"
  end

  CONTENT = <<~HTML
    <h2>Mandala Chikitsa: 48 days of mindful living</h2>
    <p>Mandalam is an invitation to slow down, reconnect with yourself, and experience a way of living inspired by Ayurveda, yoga, nature, mindful routines, and reflection at ArogyaM, Sacred Grove, Chowdepalli.</p>
    <p>A Mandala Chikitsa is a traditional Ayurvedic approach to a therapeutic lifestyle reset over 48 days. Step away from the demands of everyday life and dedicate time to wellbeing in a serene natural environment, with a disciplined yet unhurried lifestyle shaped around your individual needs.</p>
    <h2>Programme dates and arrival</h2>
    <p><strong>Main programme: 17 January 2027 – 6 March 2027.</strong></p>
    <p>Participants may choose a starting date between <strong>12 and 17 January 2027</strong>, subject to programme arrangements.</p>
    <p>Participation is limited to a <strong>maximum of 10 participants</strong>, allowing personal attention and closer interaction with the Vaidya and programme team.</p>
    <h2>Personalised Ayurvedic care</h2>
    <p>Upon registration, each participant will have an online consultation with our Vaidya to understand their health background, lifestyle, and wellbeing concerns. Ayurveda recognises individual constitution, habits, and circumstances; no two plans need be exactly alike.</p>
    <p>The Vaidya will prepare an individual wellness and treatment plan, including:</p>
    <ul>
      <li>14-day Ayurvedic Panchakarma treatment, subject to the Vaidya’s assessment.</li>
      <li>Dietary guidance.</li>
      <li>Daily routine and lifestyle practices.</li>
      <li>Yoga and relaxation practices.</li>
      <li>Meditation.</li>
    </ul>
    <p>Where considered appropriate by the Vaidya, internal Ayurvedic medicines may also be recommended.</p>
    <h2>Dinacharya: a daily rhythm for wellbeing</h2>
    <p>With guidance, support, and assistance, experience an Ayurvedic daily routine encompassing waking, personal care, food, activity, rest, yoga, meditation, and sleep. The intention is to understand how mindful daily habits can become part of your ongoing lifestyle.</p>
    <h2>Nourishment, yoga, and meditation</h2>
    <p>Pure vegetarian food is prepared with consideration for Ayurvedic principles and guidance from Ayurveda physicians. Food and dietary practices may be adapted to individual requirements identified during the consultation.</p>
    <p>Daily guided Yoga Asanas support awareness, flexibility, and wellbeing. Yoga Nidra encourages deep relaxation and mindful awareness. The Adwaita Meditation Hall offers a dedicated space for silent meditation and contemplation.</p>
    <p>Discussions on Ashtanga Yoga explore yoga as a broader discipline of self-awareness and inner development.</p>
    <h2>Learning, nature, and unhurried time</h2>
    <p>Attend Ayurvedic lectures, join discussions and screenings based on the teachings of Sri M, and explore the library’s rich collection of books for learning, self-growth, and reflection.</p>
    <p>Nature walks offer time to reconnect with the surroundings. Time in the goshala offers a peaceful connection with nature and a simple way of living.</p>
    <p>Free days and unstructured time are included so that you can rest, reflect, and experience the programme without an unnecessarily rushed schedule.</p>
    <h2>A visit to the Babaji temple</h2>
    <p>The programme includes a one-day visit to a Babaji temple in Madanapalle. Further details and travel arrangements will be shared with registered participants.</p>
    <h2>Programme fee and inclusions</h2>
    <p><strong>Fee: ₹1,85,400 for the 48-day programme.</strong></p>
    <p>The fee includes accommodation, food, treatments, consultations, yoga sessions, the temple visit, and health parameter tests advised by the Vaidya.</p>
  HTML

  BENEFITS = <<~HTML
    <ul>
      <li>A serene natural setting and time away from the demands of city life.</li>
      <li>Personalised Ayurvedic guidance and traditional treatments under appropriate supervision.</li>
      <li>Pure vegetarian Ayurvedic cuisine and support in practising Dinacharya.</li>
      <li>Daily Yoga Asanas, Yoga Nidra, and access to the Adwaita Meditation Hall.</li>
      <li>Ayurvedic lectures, Ashtanga Yoga discussions, and sessions on Sri M’s teachings.</li>
      <li>Nature walks, time in the goshala, library access, and space for rest and reflection.</li>
      <li>A one-day visit to a Babaji temple in Madanapalle.</li>
    </ul>
  HTML

  def up
    MigrationPackage.reset_column_information
    return if MigrationPackage.exists?(slug: "mandalam")

    programme = MigrationPackage.create!(
      name: "Mandalam",
      slug: "mandalam",
      short_description: "A 48-day Ayurvedic journey of personalised care, yoga, and mindful living at Sacred Grove. Limited to 10 participants.",
      duration: "48",
      dates: "17 January 2027 – 6 March 2027",
      cost: "1,85,400",
      published: true,
      special: true
    )

    {
      content: CONTENT,
      benefits: BENEFITS,
      eligibility: "<p>Open to adults aged <strong>18–75 years</strong>. Participation and the suitability of specific Ayurvedic practices or treatments will be determined through consultation with the Vaidya.</p>",
      note: "<p>Maximum 10 participants. Flexible arrival between <strong>12 and 17 January 2027</strong>, subject to programme arrangements. Each participant receives an online consultation with the Vaidya upon registration to plan their individual care.</p>"
    }.each do |name, body|
      MigrationRichText.create!(record_type: "Package", record_id: programme.id, name: name, body: body)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Unpublish Mandalam through the admin interface to preserve its content and registrations."
  end
end
