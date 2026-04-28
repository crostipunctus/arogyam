module PackagesHelper
  def package_image(package)
    if package.package_image.attached?
      image_tag(rails_public_blob_url(package.package_image.variant(:hero)), class: "PackImage", id: "package-image", alt: "#{package.name} - Ayurvedic wellness programme at ArogyaM", loading: "lazy")
    else
      image_tag "flowers.jpg", alt: "#{package.name} - ArogyaM wellness programme", id: "package-image", loading: "lazy"
    end
  end

  

end

 