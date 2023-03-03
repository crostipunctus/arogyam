class AnnouncementsController < ApplicationController 
  before_action :authenticate_user!, only: [:new, :edit, :create, :destroy]

  before_action :require_admin, only: [:new, :edit, :create, :destroy]

  def index 
    @announcements = Announcement.all 
  end 


  def new 
    @announcement = Announcement.new
  end 

  

  def create 
    @announcement = Announcement.create(announcement_params)
    if @announcement.save 
      redirect_to root_path, notice: "Announcement created"
    else  
      render :new, status: :unprocessable_entity
    end 
  end 

  def edit 
    @announcement = Announcement.find(params[:id]) 
  end 

  def update  
    @announcement = Announcement.find(params[:id])
    @announcement.update(announcement_params)

    if @announcement.save 
      redirect_to announcements_path, notice: "Announcement updated"
    else  
      render :edit, status: :unprocessable_entity
    end 
  end 

  def destroy 

  end 

  private 

  def announcement_params 
    params.require(:announcement).permit(:content)
  end 

end 