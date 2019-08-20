class ProjectsController < ApplicationController
  before_action :authenticate_user!
  add_breadcrumb 'Projects', :projects_path
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html
    end
  end

  def new
    add_breadcrumb 'New Project', :new_project_path
    respond_to do |format|
      format.html
    end
  end

  def create
    create_and_save_project; return if performed?
  end

  def show
    @project = Project.find(params[:id])
    @document = Document.new
    @issues = @project.issues
    @issue_types = IssueType.issue_types_for_projects(@project)
    @issue_states = IssueState.issue_states_for_projects(@project)
    @comments = @project.comments
    @comment = Comment.new
    add_breadcrumb @project.title, :project_path
    respond_to do |format|
      format.html
    end
  end

  def edit
    add_breadcrumb @project.title, :project_path
    add_breadcrumb 'Edit', :edit_project_path
    respond_to do |format|
      format.html
    end
  end

  def update
    if @project.update(project_params)
      flash[:notice] = t('projects.update.success')
      redirect_to @project
    else
      render 'edit'
    end
  end

  def destroy
    if @project.dependent_issues?
      flash[:error] = t('projects.destroy.dependent_issues', count: @project.issues.count)
    else
      @project.destroy
      if @project.destroyed?
        flash[:notice] = t('projects.destroy.success')
      else
        flash[:error] = @project.errors.full_messages
      end
    end
    respond_to do |format|
      format.html { redirect_to projects_path }
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :description)
  end

  def create_and_save_project
    if @project.save
      flash[:notice] = t('projects.create.success')
      redirect_to @project
    else
      render :new
    end
  end
end
