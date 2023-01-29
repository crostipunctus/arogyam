class TestimonialsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy]

  before_action :require_admin, only: [:new, :edit, :destroy]


  def index 
    @testimonials = Testimonial.order(:name) 
  end 

  def new 
    @testimonial = Testimonial.new 
  end 

  def create 
    @testimonial = Testimonial.create(testimonial_params)
    if @testimonial.save 
      flash[:notice] = "Testimonial successfully created!"
      redirect_to testimonials_path 
    else  
      render :new, status: :unprocessable_entity
    end 
  end 

  def edit 

  end 

  def update 

  end 

  def destroy 
    @testimonial = Testimonial.find(params[:id])
    @testimonial.destroy 

    redirect_to testimonials_path

  end 

  private 

  def testimonial_params
    params.require(:testimonial).permit(:title, :youtube_id)
  end 




end
