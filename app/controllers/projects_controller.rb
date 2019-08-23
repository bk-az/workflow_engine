class ProjectsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource find_by: 'sequence_num'
  add_breadcrumb 'Projects', :projects_path

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
    if @project.save
      flash[:notice] = t('projects.create.success')
      redirect_to @project
    else
      flash.now[:error] = @project.errors.full_messages
      render :new
    end
  end

  def show
    add_breadcrumb @project.title, :project_path
    @document = current_tenant.documents.new
    @issues = @project.issues
    @issue_types = current_tenant.issue_types.for_projects(@project)
    @issue_states = current_tenant.issue_states.for_projects(@project)
    @comments = @project.comments
    @comment = current_tenant.comments.new
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
end
