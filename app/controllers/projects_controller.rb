class ProjectsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html
    end
  end

  def new
    respond_to do |format|
      format.html
    end
  end

  def create
    if @project.save
      flash[:notice] = t('projects.create.created')
      redirect_to @project
    else
      render :new
    end
  end

  def show
    @project = Project.find(params[:id])
    @document = Document.new
    @issues = @project.issues
    @issue_types = IssueType.issue_types_for_projects(@project)
    @issue_states = IssueState.issue_states_for_projects(@project)
    @comments = @project.comments
    @comment = Comment.new
    respond_to do |format|
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    if @project.update(project_params)
      flash[:notice] = t('projects.update.updated')
      redirect_to @project
    else
      render 'edit'
    end
  end

  def destroy
    if @project.destroy
      flash[:notice] = t('projects.destroy.destroyed')
      redirect_to projects_path
    else
      flash.now[:notice] = t('projects.destroy.not_destroyed')
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :description)
  end
end
