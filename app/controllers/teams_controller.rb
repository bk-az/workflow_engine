class TeamsController < ApplicationController
  load_and_authorize_resource
  # GET /index
  def index
    respond_to do |format|
      format.html
    end
  end
  # GET /new
  def new
    @team = Team.new
    respond_to do |format|
      format.html
    end
  end
  # GET /show
  def show
    @team_memberships = TeamMembership.where('team_id = ? ', @team.id)
    already_present_member_ids = @team_memberships.pluck(:user_id)
    @all_members = current_tenant.users.where.not(id: already_present_member_ids).select(:id, :first_name)
    respond_to do |format|
      format.html
    end
  end
  # POST /create
  def create
    if @team.save
      team_created = true
      flash[:notice] = t('team.create.success')
      begin
        @team.team_memberships.create!(is_team_admin: true, is_approved: true, user_id: current_user.id)
      rescue StandardError
        flash.now[:error] = @team.errors.full_messages
      end
    else
      team_created = false
      flash[:error] = @team.errors.full_messages
    end
    respond_to do |format|
      format.html do
        if team_created
          redirect_to teams_path
        else
          flash[:notice] = @team.errors.full_messages
          render 'new'
        end
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  # POST /update
  def update
    if @team.update(team_params)
      flash[:notice] = t('team.update.success')
      team_updated = true
    else
      flash.now[:error] = @team.errors.full_messages
      team_updated = false
    end

    respond_to do |format|
      format.html do
        if team_updated
          redirect_to teams_path
        else
          render 'edit'
        end
      end
    end
  end

  def destroy
    if @team.destroy
      flash[:notice] = t('team.destroy.success')
    else
      flash.now[:error] = @team.errors.full_messages
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

  def add_membership
    @is_admin = params[:join_admin][:joining_decision] != '0'
    @team_membership = TeamMembership.new(is_team_admin: @is_admin, is_approved: params[:is_approved], team_id: params[:team_id], user_id: params[:user_id])
    respond_to do |format|
      if @team_membership.save
        format.js
      else
        flash.now[:error] = @team_membership.errors.full_messages
      end
    end
  end


  def approve_request
    TeamMembership.find_by(team_id: params[:team_id] , user_id: params[:user_id]).update(is_approved: true)
  end
end
