class TestimonialsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy]

  before_action :require_admin, only: [:new, :edit, :destroy]


  def index 
    @testimonials = Testimonial.all
  end 

  def new 
    @testimonial = Testimonial.new 
  end 

  def create 
    @testimonial = Testimonial.create(testimonial_params)
    if @testimonial.save 
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

  end 

  private 

  def testimonial_params
    params.require(:testimonial).permit(:title, :youtube_id)
  end 




end
