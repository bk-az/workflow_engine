class MembershipsController < ApplicationController
  def index
    @project = Project.includes(:users, :teams).find(params[:project_id])
    @users = @project.users
    @teams = @project.teams
  end

  def create
    @project = Project.find(params[:project_id])
    if params[:member] == 'Team'
      Team.find_by_name! params[:member_name]
    else # it is user
      User.find_by_first_name! params[:member_name]
    end.projects << @project
    redirect_to project_memberships_path(@project)
  end

  def destroy
    @project = Project.find(params[:project_id])
    ProjectMembership.find(params[:id]).destroy
    redirect_to project_memberships_path(@project)
  end
end
