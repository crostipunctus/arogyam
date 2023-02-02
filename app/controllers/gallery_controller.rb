class GalleryController < ApplicationController 
  before_action :authenticate_user!, only: [:new, :create]

  before_action :require_admin, only: [:new, :create]

  def new 
    @gallery = Gallery.new 
  end 

  def create 
    @gallery = Gallery.create!(gallery_params)
    redirect_to root_path
  end 

  private 

    def gallery_params 
      params.require(:gallery).permit(:title, images:[])
    end 

end 