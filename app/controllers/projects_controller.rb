class ProjectsController < ApplicationController
  load_and_authorize_resource
  before_action :current_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.all
    respond_to do |format|
      format.html
    end
  end

  def new
    @project = Project.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @project = Project.new(project_params)
    @project.company_id = 1
    if @project.save
      redirect_to @project, notice: 'Successfully created a project.'
    else
      render :new
    end
  end

  def show
    @issues = @project.issues
    @issue_types = IssueType.all
    @issue_states = IssueState.all
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
      flash[:notice] = 'Project updated successfully!'
      redirect_to @project
    else
      render 'edit'
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path
  end

  private

  def project_params
    params.require(:project).permit(:title, :description)
  end

  def current_project
    @project = Project.find(params[:id])
  end
end
