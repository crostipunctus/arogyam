class RegistrationsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :require_admin, only: [:edit, :update,  :destroy]

  def new 

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
