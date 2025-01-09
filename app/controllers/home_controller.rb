class HomeController < ApplicationController

  def index 
    @packages = Package.with_attached_package_image.all
  end 

 def test 
 end 
  
end
