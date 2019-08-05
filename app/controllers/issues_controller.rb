# Issues Controller
class IssuesController < ApplicationController
  load_and_authorize_resource
  # GET /issues
  def index
    @issues = @issues.order(:project_id).page(params[:page])
    @issue_types = current_tenant.issue_types.all
    @issue_states = current_tenant.issue_states.all
    @projects = current_user.visible_projects
    @assignees = current_tenant.users.all
    respond_to do |format|
      format.html
    end
  end

  # GET /issues/filter
  def filter
    @issues = @issues.where(search_params).page(params[:page])
    respond_to do |format|
      format.js
    end
  end

  # GET projects/:id/issues/new
  def new
    @assignees = current_tenant.users.all
    @issue_types = current_tenant.issue_types.all
    @issue_states = current_tenant.issue_states.all
    @project = current_tenant.projects.find(params[:project_id])
    respond_to do |format|
      format.html
    end
  end

  # GET projects/:id/issues/:id
  def show
    respond_to do |format|
      format.html
    end
  end

  # GET projects/:id/issues/:id/edit
  def edit
    @assignees = current_tenant.users.all
    @issue_types = current_tenant.issue_types.all
    @issue_states = current_tenant.issue_states.all
    @project = @issue.project
    respond_to do |format|
      format.html
    end
  end

  # PUT projects/:id/issues/:id
  def update
    if @issue.update(issue_params)
      flash[:notice] = t('issues.update.notice')

      respond_to do |format|
        format.html { redirect_to project_issue_path(@issue.project, @issue) }
      end
    else
      flash.now[:error] = @issue.errors.full_messages
      render 'edit'
    end
  end

  # POST projects/:id/issues
  def create
    @issue.creator_id = current_user.id
    if @issue.save
      flash[:notice] = t('issues.create.notice')
      respond_to do |format|
        format.html { redirect_to project_issue_path(@issue.project, @issue) }
      end
    else
      flash.now[:error] = @issue.errors.full_messages
      render 'new'
    end
  end

  # DELETE projects/:id/issues/:id
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
    params.
      # Optionally, whitelist your search parameters with permit
      permit(:project_id, :assignee_id, :issue_state_id, :issue_type_id).
      # Delete any passed params that are nil or empty string
      delete_if { |_key, value| value.blank? }
  end
end
