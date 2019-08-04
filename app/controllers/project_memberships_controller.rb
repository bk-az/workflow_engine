class ProjectMembershipsController < ApplicationController
  authorize_resource

  # GET #index
  def index
    load_project_with_members
    @project_membership = ProjectMembership.new
    respond_to do |format|
      format.html
    end
  end

  # POST #create
  def create
    @result, @member, @project = ProjectMembership.create_membership(project_membership_params)
    if @result
      flash.now[:success] = t('.created')
    else
      flash.now[:danger] = t('.not_created')
    end

    respond_to do |format|
      format.js
    end
  end

  # DELETE #destroy
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
    # byebug
    if params[:term].length > 1
      @project = Project.find(params[:project_id])
      @members = ProjectMembership.autocomplete_member(
        params[:member_type],
        params[:term],
        @project
      )
    end
    respond_to do |format|
      format.json
    end
  end

  private

  def project_membership_params
    params.require(:project_membership).permit(:project_id, :project_member_id, :project_member_type)
  end

  def load_project_with_members
    @project = Project.includes(:users, :teams).find(params[:project_id])
    @users = @project.users
    @teams = @project.teams
  end
end
