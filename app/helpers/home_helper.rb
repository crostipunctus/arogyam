module HomeHelper

  def go_to_package(package_name)
    @package = Package.find_by(name: package_name)
    
  end 
  

end
