class ProjectMembershipsController < ApplicationController
  authorize_resource

  # GET #index
  def index
    load_project_with_members
    respond_to do |format|
      format.html
    end
  end

  # POST #create
  def create
    @member, @project = ProjectMembership.create_membership(
      params[:project_member_type],
      params[:project_member_id],
      params[:project_id]
    )
    flash.now[:success] = t('.notice') unless @member.nil?
    respond_to do |format|
      format.js
    end
  end

  # DELETE #destroy, id: params[:id]
  def destroy
    pm = ProjectMembership.destroy(params[:id])
    @member_id = "\##{pm.project_member_type}_#{pm.project_member_id}"
    respond_to do |format|
      format.html { redirect_to project_project_memberships_path(@project) }
      format.js
    end
  end

  # GET #search
  def search
    if params[:search_name].present?
      @project = Project.find(params[:project_id])
      @members = ProjectMembership.search_for_membership(
        params[:member_type],
        params[:search_name],
        @project
      )
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def load_project_with_members
    @project = Project.includes(:users, :teams).find(params[:project_id])
    @users = @project.users
    @teams = @project.teams
  end
end
