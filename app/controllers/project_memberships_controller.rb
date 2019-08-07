class ProjectMembershipsController < ApplicationController
  load_resource :project
  load_and_authorize_resource through: :project, shallow: true
  # GET #index
  def index
    @users = @project.users
    @teams = @project.teams
    # needed for new membership modal
    @project_membership = ProjectMembership.new
    respond_to do |format|
      format.html
    end
  end

  # POST #create
  def create
    if @project_membership.save
      @project_member = @project_membership.project_member
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
    @project_membership.destroy
    @deleted_view_id = "\##{@project_membership.project_member_type}_#{@project_membership.project_member_id}"
    respond_to do |format|
      format.js
    end
  end

  # GET #search
  def search
    # @project will be loaded by cancancan
    if params[:term].length > 1
      @search_results = ProjectMembership.autocomplete_member(
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
    params.require(:project_membership).permit(:project_member_id, :project_member_type)
  end
end
