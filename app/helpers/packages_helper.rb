module PackagesHelper

  def cost(cost)
    "Rs.%.2f" % cost
  end

  def package_image(package)
    if package.package_image.attached?
      image_tag package.package_image
    else
      image_tag "flowers.jpg"
    end
  end
end
