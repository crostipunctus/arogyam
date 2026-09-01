class HomeController < ApplicationController

  def index
    @featured_packages = Package.published.with_attached_package_image
                                .order(:name)
                                .limit(3)
  end

 def test 
 end 
  
end
