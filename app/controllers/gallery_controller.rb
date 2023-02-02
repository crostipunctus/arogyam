class GalleryController < ApplicationController 
  

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