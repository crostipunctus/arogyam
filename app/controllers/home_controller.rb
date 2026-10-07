class HomeController < ApplicationController

  def index
    @special_package = Package.published.special.order(:name).first
    @featured_packages = Package.published.with_attached_package_image
                                .where.not(id: @special_package&.id)
                                .order(:name)
                                .limit(3)
  end

 def test 
 end 
  
end
