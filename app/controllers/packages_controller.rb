class PackagesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :destroy]

  before_action :require_admin, only: [:new, :edit, :create, :destroy]

  def index 
    @packages = Package.order(:name) 
  end 

  def show 
    @package = Package.find_by!(slug: params[:id])
  end 

  def new 
    @package = Package.new 
  end 

  def create  
    @package = Package.create(package_params)
    if @package.save
      redirect_to programme_path(@package)
    else  
      render :new, status: :unprocessable_entity
    end 
  end 

  def edit 
    @package = Package.find_by!(slug: params[:id])
  end 

  def update 
    @package = Package.find_by!(slug: params[:id])
    @package.update(package_params)

    if @package.save 
      flash[:notice] = "Package successfully updated!"
      redirect_to programme_path(@package) 
    else  
      render :edit, status: :unprocessable_entity
    end

  end 

  def destroy 
    
    @package = Package.find(params[:id])
    @package.destroy 

    redirect_to packages_path
  end 

  private 

  def package_params 
    params.require(:package).permit(:name, :cost, :duration, :content, :eligibility, :note, :package_image, :short_description, :dates, :benefits)
  end



end
