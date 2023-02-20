module PackagesHelper
  def package_image(package)
    if package.package_image.attached?
      image_tag(rails_public_blob_url(package.package_image), class: "PackImage", alt: 'package-image')
    else
      image_tag "flowers.jpg", alt: 'flower-placeholder'
    end
  end
end

