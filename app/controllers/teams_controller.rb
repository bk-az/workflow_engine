class TeamsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource find_by: :sequence_num, through: :current_tenant

  # GET /index
  def index
    @team = Team.new
    respond_to do |format|
      format.html
    end
  end

  # GET /new
  def new

    respond_to do |format|
      format.html
    end
  end

  # GET /show
  def show
    @team_memberships, @all_members = @team.member_and_team_memberships
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
    else
      flash[:error] = @team.errors.full_messages
    end

    respond_to do |format|
      format.html do
        redirect_to team_path
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

  def add_membership
    @is_admin = params[:join_admin][:joining_decision] != '0'
    @team_membership = TeamMembership.new(is_team_admin: @is_admin, is_approved: params[:is_approved], team_id: params[:team_id], user_id: params[:user_id])
    if @team_membership.save
      respond_to do |format|
        format.js
      end
    else
      flash.now[:error] = @team_membership.errors.full_messages
    end
  end

  def remove_member
    @team_membership = @team.team_memberships.find_by(id: params[:membership_id])
    if @team_membership.present?
      respond_to do |format|
        if @team_membership.destroy
          flash[:notice] = t('team.remove_member.success')
          format.js
        else
          flash.now[:error] = @team_membership.errors.full_messages
          render 'index'
        end
      end
    end
  end

  def approve_request
    TeamMembership.find_by(team_id: params[:team_id], user_id: params[:user_id]).update(is_approved: true)
  end

  private

  def team_params
    params.require(:team).permit(:name, :company_id)
  end

  def team_membership_params
    params.require(:team_memberships).permit(:is_team_admin, :is_approved, :team_id, :user_id)
  end
end
