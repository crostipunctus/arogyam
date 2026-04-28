namespace :variants do
  desc "Pre-generate Active Storage variants for existing attachments so the first user request doesn't pay the processing cost"
  task warm: :environment do
    targets = [
      [Blog,        :image,         %i[thumb hero]],
      [Package,     :package_image, %i[card hero]],
      [TeamMember,  :avatar,        %i[thumb]],
      [Gallery,     :images,        %i[thumb large]]
    ]

    targets.each do |klass, attachment, variants|
      klass.find_each do |record|
        attached = record.public_send(attachment)
        items = attached.respond_to?(:each) ? attached : [attached].compact
        items.each do |att|
          next unless att.attached? rescue next
          variants.each do |v|
            begin
              att.variant(v).processed
              print "."
            rescue => e
              warn "\n#{klass}##{record.id} #{attachment} #{v}: #{e.class}: #{e.message}"
            end
          end
        end
      end
    end
    puts "\nDone."
  end
end
