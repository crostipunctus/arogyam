module HomeHelper

  def package_link(name)
    
    package = Package.find_by(name: name)
 
    link_to "#{name}", package_path(package)
  end

end
