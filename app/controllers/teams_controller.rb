class TeamsController < ApplicationController

  def index
    @all_teams = Team.all

  end


  def new
    @team = Team.new
  end

  def show
    @team = Team.find(params[:id])
    @team_memberships = TeamMembership.where("team_id = ? ", @team.id)
    # @team_memberships = TeamMembership.where(team_id: @team.id)
    # sql = "select u.* from users as u left join team_memberships as m on u.id = m.user_id and m.team_id = #{@team.id} where team_id is null;"
   
    # already_present_member_ids = @team_memberships.select(:user_id).to_a.map { |d| d.user_id }.uniq
    # @all_members = ActiveRecord::Base.connection.execute(sql)
   
    # binding.pry

    # @all_members = User.where('id not in (?)', already_present_member_ids)
    # user_ids = Array.new
    # @team_memberships.each do |team_membership|
    #  user_ids << team_membership.user_id
    # end

    # @all_members =User.where('id NOT IN (?)', user_ids)

    # binding.pry
    # already_present_member_ids = @team_memberships.select(:user_id).to_a.map { |d| d.user_id }.uniq
    # @all_members = User.where("id NOT IN (?)", already_present_member_ids.join(','))
    # binding.pry
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      flash[:team_created] = 'Team created Successfully'

      ## CANCANCAN 
    ## find last team currently created ##
    ## get its team id ##
    ## get current user id ##
    ## add user in team membership with is_admin  true ## person who created team is also a admin



  #############

  redirect_to teams_path
else
  flash[:team_not_created] = 'Team not created'
  render 'new'
end
end

def edit
  @team = Team.find(params[:id])
    # respond_to do |format|
    #   format.html
    # end
  end

  def update
    @team = Team.find(params[:id])
    if @team.update(team_params)
      redirect_to teams_path notice: t('.notice')
    else
      render 'edit'
    end
  end

  def destroy
    @team = Team.find(params[:id])
    if @team.destroy
      flash[:team_deleted] = 'Successfully deleted team!'
      redirect_to teams_path
    else
      flash[:team_not_deleted] = 'Error deleting team!'
    end
  end

  def team_params
    params.require(:team).permit(:name,:company_id)

  end
  def team_membership_params
    params.require(:team_memberships).permit(:is_team_admin, :is_approved, :team_id, :user_id )
  end

  def add_member ## add member in team membership

    # binding.pry
    @selected_member_id = params[:member_id]
    if params[:param_name1][:result] == '0'
      @is_admin = false
    else
      @is_admin = true
    end
    @team_id = params[:team_id]
    @team_membership = TeamMembership.new(is_team_admin: @is_admin, is_approved: false, team_id: @team_id, user_id: @selected_member_id)
   

    @team_membership.save
    respond_to do |format|
      format.js
    end
  end


end
