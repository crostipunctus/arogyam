module PackagesHelper
  def package_image(package)
    if package.package_image.attached?
      image_tag(rails_public_blob_url(package.package_image.variant(:hero)), class: "PackImage", id: "package-image", alt: "#{package.name} - Ayurvedic wellness programme at ArogyaM", loading: "lazy")
    else
      image_tag "flowers.jpg", alt: "#{package.name} - ArogyaM wellness programme", id: "package-image", loading: "lazy"
    end
  end

  # Split rendered Action Text at its top-level headings, preserving inline
  # formatting and rendered attachments. Unstructured content remains one section.
  def programme_content_sections(rich_text)
    return [] if rich_text.blank?

    fragment = Nokogiri::HTML.fragment(rich_text.to_s)
    content = fragment.at_css(".trix-content") || fragment
    sections = []
    section = { heading: nil, body: +"" }

    content.children.each do |node|
      if %w[h1 h2].include?(node.name)
        sections << section if section[:heading].present? || section[:body].strip.present?
        section = { heading: node.text, body: +"" }
      else
        section[:body] << node.to_html
      end
    end

    sections << section if section[:heading].present? || section[:body].strip.present?
    sections
  end

  def programme_duration(package)
    duration = package.duration.to_s.strip
    duration.match?(/\A\d+\z/) ? "#{duration} days" : duration
  end

end
