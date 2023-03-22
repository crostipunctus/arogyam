class BatchesController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :create, :destroy]
  before_action :require_admin, only: [:show, :edit, :update, :create, :destroy]

  def index 
    @batches = Batch.all 
   
  end 

  def new 

  end 

  def show 
    @batch = Batch.find(params[:id])

    @students = @batch.users
    
  end 

  def create  

  end 

  def edit  

  end 

  def update 

  end 

  def destroy 

  end 




end
