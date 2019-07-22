class ProjectsController < ApplicationController
  before_action :current_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
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
    @issues = Project.find(params[:id]).issues.all
    @projects = Project.all
  end

  def edit
  end

  def update
    if @project.update(project_params)
      flash[:update_project] = 'Project updated successfully!'
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
