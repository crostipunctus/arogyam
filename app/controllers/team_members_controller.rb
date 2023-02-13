class TeamMembersController < ApplicationController
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
      render :new, alert: "Couldnt not create team member. Please try again" 
    end 
  end 

  def edit
  end

  def update
  end

  def destroy
  end

  private 

  def team_member_params 
    params.require(:team_member).permit(:name, :content, :role, :avatar)
  end 
end
