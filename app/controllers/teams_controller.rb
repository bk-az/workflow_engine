class TeamsController < ApplicationController
  load_and_authorize_resource

  def index
    @all_teams = Team.all
    respond_to do |format|
      format.html
    end
  end

  def new
    @team = Team.new
    respond_to do |format|
      format.html
    end
  end

  def show
    @team = Team.find(params[:id])
    @team_memberships = TeamMembership.where('team_id = ? ', @team.id)
    already_present_member_ids = @team_memberships.pluck(:user_id)
    @all_members = User.where.not(id: already_present_member_ids).select(:id, :first_name)
    respond_to do |format|
      format.html
    end
  end

  def create
    @team = Team.new(team_params)
    @team.company_id = current_tenant.id ## need to be changed

    if @team.save
      TeamMembership.create!(is_team_admin: true, is_approved: false, team_id: Team.last.id, user_id: current_user.id)
      flash[:notice] = t('.Team created Successfully')
      respond_to do |format|
        format.html { redirect_to teams_path }
      end
    else
      flash[:notice] = t('.Team not created')
      render 'new'
    end
  end

  def edit
    @team = Team.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def update
    @team = Team.find(params[:id])
    if @team.update(team_params)
      flash[:notice] = t('.Team Successfully updated!')
      respond_to do |format|
        format.html { redirect_to teams_path }
      end
    else
      flash[:notice] = t('.Team not updated!')
      render 'edit'
    end
  end

  def destroy
  
    if Team.find(params[:id]).destroy
      flash[:notice] = t('.Successfully deleted team!')
    else
      flash[:notice] = t('.Error deleting team!')
    end
    respond_to do |format|
      format.html { redirect_to teams_path }
    end
  end

  def team_params
    params.require(:team).permit(:name, :company_id)
  end

  def team_membership_params
    params.require(:team_memberships).permit(:is_team_admin, :is_approved, :team_id, :user_id)
  end

  ## add member in team membership
  def add_member
    @is_approved = false
    add_membership(@is_approved)
  end

  # change status of user "is_approved = true" on request to join team
  def join_team
    @is_approved = true
    add_membership(@is_approved)
  end

  def add_membership(is_approved)
    @user_id = params[:user_id]
    @team_id = params[:team_id]
    @is_admin = if params[:join_admin][:result] == '0'
                  false
                else
                  true
    end
    @team_membership = TeamMembership.new(is_team_admin: @is_admin, is_approved: is_approved, team_id: @team_id, user_id: @user_id)
    if @team_membership.save
      respond_to do |format|
        format.js
      end
    end
  end
end
