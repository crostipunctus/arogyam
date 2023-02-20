class GalleryController < ApplicationController 
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]

  def index 
    @gallery = Gallery.find(2)
    @images = @gallery.images
  end 

  def new 
    @gallery = Gallery.new 
  end 

  def create 
    @gallery = Gallery.create!(gallery_params)
    redirect_to root_path
  end 

  def edit 
    @gallery = Gallery.find(params[:id])
  end 

  def update 
    @gallery = Gallery.find(params[:id])

    if @gallery.update(gallery_params)
      if params[:images]
        params[:images].each do |image|
          @gallery.images.attach(image)
        end 
      end 
      redirect_to root_path, notice: 'Gallery was succesfully updates'
    else  
      render :edit, status: :unprocessable_entity
    end 
  end 

  def destroy 
    gallery = Gallery.find(params[:id])
    image = gallery.images.find(params[:param2])

    image.destroy

    redirect_to root_path, notice: 'Image deleted succesfully'
  end 

  private 

    def gallery_params 
      params.require(:gallery).permit(:title, images:[])
    end 

end 