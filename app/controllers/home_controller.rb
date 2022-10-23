class HomeController < ApplicationController

  def index 
    @packages = Package.order(:name)
  end 
  
end
