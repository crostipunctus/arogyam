class HomeController < ApplicationController

  def index 
    @packages = Package.order(:name)
  end 

 def test 
    @packages = Package.order(:name)
 end 
  
end
