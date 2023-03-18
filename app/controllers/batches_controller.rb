class BatchesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :create, :destroy]
  before_action :require_admin, only: [:new, :edit, :update, :create, :destroy]

  def index 
    @batches = Batch.all 
    @registrations = Registration.all
  end 

  def new 

  end 

  def show 

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
