# Issues Controller
class IssuesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :project, find_by: :sequence_num
  load_and_authorize_resource through: :project, find_by: :sequence_num, except: %i[index history filter]
  load_and_authorize_resource find_by: :sequence_num, only: %i[index history filter]

  # GET /issues
  def index
    if params[:issue_type_id].present?
      @issues = current_tenant.issues.where(issue_type_id: params[:issue_type_id])
    elsif params[:issue_state_id].present?
      @issues = current_tenant.issues.where(issue_state_id: params[:issue_state_id])
    else
      add_breadcrumb 'All Issues', :issues_path
      @projects = current_user.visible_projects
      @issues = @issues.order(:project_id).page(params[:page])
      @issue_types = current_tenant.issue_types.all
      @issue_states = current_tenant.issue_states.all
      @assignees = current_tenant.users.all
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /issues/filter
  def filter
    @issues = Issue.search(search_params, params[:search_issue]).page(params[:page])
    respond_to do |format|
      format.js
    end
  end

  # GET projects/:project_id/issues/new
  def new
    @assignees = current_tenant.users.all
    @issue_types = current_tenant.issue_types.project_issue_types(@project.id)
    @issue_states = current_tenant.issue_states.all
    add_breadcrumb 'Projects', :projects_path
    add_breadcrumb @project.title, project_path(@project)
    add_breadcrumb 'New Issue', :new_project_issue_path
    respond_to do |format|
      format.html
    end
  end

  # GET projects/:project_id/issues/:id
  def show
    add_breadcrumb 'Projects', :projects_path
    add_breadcrumb @issue.project.title, project_path(@issue.project)
    add_breadcrumb @issue.title, :project_issue_path
    @document = Document.new
    @comment = Comment.new
    @comments = @issue.comments
    respond_to do |format|
      format.html
    end
  end

  # GET projects/:project_id/issues/:id/edit
  def edit
    add_breadcrumb 'Projects', :projects_path
    add_breadcrumb @issue.project.title, project_path(@issue.project)
    add_breadcrumb @issue.title, :project_issue_path
    add_breadcrumb 'Edit', :edit_project_issue_path
    @project = @issue.project
    @assignees = current_tenant.users.all
    @issue_types = current_tenant.issue_types.project_issue_types(@project.id)
    @issue_states = current_tenant.issue_states.all
    respond_to do |format|
      format.html
    end
  end

  # PUT projects/:project_id/issues/:id
  def update
    if @issue.update(issue_params)
      flash[:notice] = t('issues.update.notice')
      respond_to do |format|
        format.html { redirect_to project_issue_path(@issue.project, @issue) }
      end
    else
      add_breadcrumb 'Projects', :projects_path
      add_breadcrumb @issue.project.title, project_path(@issue.project)
      add_breadcrumb @issue.title, :project_issue_path
      add_breadcrumb 'Edit', :edit_project_issue_path
      @assignees = current_tenant.users.all
      @issue_types = current_tenant.issue_types.all
      @issue_states = current_tenant.issue_states.all
      @project = @issue.project
      flash.now[:error] = @issue.errors.full_messages
      render 'edit'
    end
  end

  # POST projects/:project_id/issues
  def create
    @issue.creator_id = current_user.id
    if @issue.save
      flash[:notice] = t('issues.create.notice')
      respond_to do |format|
        format.html { redirect_to project_issue_path(@issue.project, @issue) }
      end
    else
      add_breadcrumb 'Projects', :projects_path
      add_breadcrumb @project.title, project_path(@project)
      add_breadcrumb 'New Issue', :new_project_issue_path
      @assignees = current_tenant.users.all
      @issue_types = current_tenant.issue_types.all
      @issue_states = current_tenant.issue_states.all
      @project = @issue.project
      flash.now[:error] = @issue.errors.full_messages
      render 'new'
    end
  end

  # DELETE projects/:project_id/issues/:id
  def destroy
    if @issue.destroy
      flash[:notice] = t('issues.destroy.notice')
      respond_to do |format|
        format.html { redirect_to project_path(@issue.project_id) }
      end
    else
      flash.now[:error] = @issue.errors.full_messages
      render 'edit'
    end
  end

  # GET /issues/:id/history
  def history
    add_breadcrumb 'Projects', :projects_path
    add_breadcrumb @issue.project.title, project_path(@issue.project_id)
    add_breadcrumb @issue.title, project_issue_path(@issue.project_id, @issue)
    add_breadcrumb 'History', history_issue_path(@issue)
    @audits = @issue.audits
    respond_to do |format|
      format.html
    end
  end

  private

  # Permits columns of issue while adding to database
  def issue_params
    params.require(:issue)
          .permit(:title, :description, :start_date, :due_date, :progress,
                  :priority, :company_id, :creator_id, :assignee_id,
                  :parent_issue_id, :project_id, :issue_state_id,
                  :issue_type_id)
  end

  # Permits columns of issue that are not blank for search
  def search_params
    params.permit(:project_id, :assignee_id, :issue_state_id, :issue_type_id)
          .delete_if { |_key, value| value.blank? }
  end
end
