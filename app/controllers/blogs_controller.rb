class BlogsController < ApplicationController
  before_action :authenticate_user!

  def index 
    @blogs = Blog.order(created_at: :asc)
  end 

  def show 
    @blog = Blog.find(params[:id])
  end 

  def new 
    @blog = Blog.new 
  end 

  def create 
    @blog = Blog.create(blog_params)
    @blog.user = current_user 

    if @blog.save 
      redirect_to blog_path(@blog)
    else  
      render :new, status: :unprocessable_entity
    end 

  end 

  private 

  def blog_params 
    params.require(:blog).permit(:title, :content)
  end 

end
