class TeamMembersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :edit, :update, :destroy]

  before_action :require_admin, only: [:index, :new, :create, :edit, :update, :destroy]

  def index
    @team = TeamMember.all 
  end

  def show
  end

  def new
    @team_member = TeamMember.new 
  end

  def create 
    
    @team_member = TeamMember.create!(team_member_params)
    if @team_member.save 
      redirect_to team_members_path, notice: "Team member created successfully"
    else  
      render :new, alert: "Couldnt not create team member. Please try again", status: :unprocessable_entity
    end 
  end 

  def edit
    @team_member = TeamMember.find(params[:id]) 

  end

  def update
    @team_member = TeamMember.find(params[:id])
    @team_member.update(team_member_params)

    if @team_member.save 
      redirect_to about_path, notice: "Team member updated"
    else  
      render :new, status: :unprocessable_entity
    end 

  end

  def destroy
    @team_member = TeamMember.find(params[:id])
    @team_member.destroy
    redirect_to about_path, status: :see_other
  end

  private 

  def team_member_params 
    params.require(:team_member).permit(:name, :content, :role, :avatar)
  end 
end
