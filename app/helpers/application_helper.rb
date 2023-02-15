module ApplicationHelper

  def logo 
    link_to image_tag('https://d1w11gv0j27jrz.cloudfront.net/symbol.png', class: "no-border-radius", width: 18), root_path, data: {turbo: false}
  end 

  def package_link(name)
    package = Package.find_by(name: name)
    link_to "#{name}", package_path(package)
  end

  def get_current_url
    request.original_url
  end

 
end
