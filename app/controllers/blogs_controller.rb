class BlogsController < ApplicationController
  
  before_action :authenticate_user!, except: [:index, :show]
  before_action :current_user_admin?, only: [:new, :edit, :destroy]

  def index 
    @blogs = Blog.order(created_at: :asc)
  end 

  def show 
    @blog = Blog.find(params[:id])
    @user = @blog.user 
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

  def edit 
    @blog = Blog.find(params[:id])
  end 

  def update 
    @blog = Blog.find(params[:id])
    @blog.update(blog_params)

    if @blog.save 
      redirect_to @blog 
    else  
      render :edit, status: :unprocessable_entity
    end 

  end 

  def destroy 
    @blog = Blog.find(params[:id])
    @blog.destroy
    redirect_to blogs_path
  end 

  private 

  def blog_params 
    params.require(:blog).permit(:title, :content)
  end 

end
