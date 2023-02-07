module PackagesHelper
  def package_image(package)
    if package.package_image.attached?
      image_tag package.package_image, src: "https://d1w11gv0j27jrz.cloudfront.net#{rails_blob_path(package.package_image, disposition: "attachment", only_path: true)}"
    else
      image_tag "flowers.jpg"
    end
  end
end
