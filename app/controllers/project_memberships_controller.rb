class ProjectMembershipsController < ApplicationController
  def index
    load_project_with_members
  end

  def create
    @membership = ProjectMembership.new(membership_params)
    if @membership.save
      flash.now[:success] = 'Member Added Successfully'
    else
      flash.now[:danger] = 'Member Not Added'
    end
    load_project_with_members
    respond_to do |format|
      format.js
    end
  end

  def destroy
    ProjectMembership.find(params[:id]).destroy
    load_project_with_members
    respond_to do |format|
      format.js
    end
  end

  def search_for
    load_project_with_members
    @members = ProjectMembership.search_for_membership(params[:member_type],
                                                       params[:search_name],
                                                       @project)
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

  def membership_params
    params.permit(:project_id, :project_member_id, :project_member_type)
  end
end
