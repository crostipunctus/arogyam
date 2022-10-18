class PackagesController < ApplicationController
  before_action :current_user_admin?, only: [:new, :edit, :destroy]

  def index 
    @packages = Package.order(:name) 
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
    @package = Package.find(params[:id])
    @package.update(package_params)

    if @package.save 
      redirect_to @package 
    else  
      redirect_to root, status: :unprocessable_entity
    end

  end 

  def destroy 
    
    @package = Package.find(params[:id])
    @package.destroy 

    redirect_to packages_path
  end 

  private 

  def package_params 
    params.require(:package).permit(:name, :cost, :duration, :content, :eligibility, :note, :package_image)
  end



end
