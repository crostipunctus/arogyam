module ApplicationHelper

  def logo 
    link_to image_tag('sparkle.png', width: 15), root_path, data: {turbo: false}
  end 

  def package_link(name)
    package = Package.find_by(name: name)
    link_to "#{name}", package_path(package)
  end

 
end
