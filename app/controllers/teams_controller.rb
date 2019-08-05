class TeamsController < ApplicationController
  load_and_authorize_resource

  def index
    @all_teams = Team.all
  end

  def new
    @team = Team.new
  end

  def show
    @team = Team.find(params[:id])
    @team_memberships = TeamMembership.where('team_id = ? ', @team.id)
    already_present_member_ids = @team_memberships.pluck(:user_id)
    @all_members = User.where.not(id: already_present_member_ids).select(:id, :first_name)
  end

  def create
    @team = Team.new(team_params)
    @team.company_id = 1 ## need to be changed

    if @team.save
      @user_id = current_user.id
      @team_id = Team.last.id
      TeamMembership.create!(is_team_admin: true, is_approved: false, team_id: @team_id, user_id: @user_id) ## person who   
      ## member who created team is by default made as admin

      redirect_to teams_path, team_created: t('.Team created Successfully')
    else
      render 'new', team_created: t('.Team not created')
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    if @team.update(team_params)
      redirect_to teams_path, team_updated: t('.Team Successfully updated!')
    else
      render 'edit'
    end
  end

  def destroy
    @team = Team.find(params[:id])
    if @team.destroy
      redirect_to teams_path, team_deleted: t('.Successfully deleted team!')
    else
      redirect_to teams_path team_not_deleted: t('.Error deleting team!')
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
