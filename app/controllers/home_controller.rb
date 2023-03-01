class HomeController < ApplicationController

  def index 
    @packages = Package.all
  end 

 def test 
 end 
  
end
