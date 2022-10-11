class PackagesController < ApplicationController

  def index 
    @packages = Package.all 
  end 

  def show 
    @package = Package.find(params[:id])
  end 

  def new 
    @package = Package.new 
  end 

  def create  
    @package = Package.create(package_params)
    if @package.save
      redirect_to @package 
    else  
      redirect_to root, status: :unprocessable_entity
    end 
  end 

  def edit 
    @package = Package.find(params[:id])
  end 

  def update 
    @package = Package.update(package_params)

    if @package.update 
      redirect_to @package 
    else  
      redirect_to root, status: :unprocessable_entity
    end

  end 

  private 

  def package_params 
    params.require(:package).permit(:name, :description, :cost, :duration)
  end



end
