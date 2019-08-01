# Issues Controller
class IssuesController < ApplicationController
  load_and_authorize_resource
  # GET /issues
  def index
    @issues = @issues.order(:project_id).page(params[:page])
    @issue_types = IssueType.all
    @issue_states = IssueState.all
    @projects = User.visible_projects(current_user)
    @assignees = User.all
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

  # GET /issues/new
  def new
    respond_to do |format|
      format.html
    end
  end

  # GET /issues/:id
  def show
    respond_to do |format|
      format.html
    end
  end

  # GET /issues/:id/edit
  def edit
    respond_to do |format|
      format.html
    end
  end

  # PUT /issues/:id
  def update
    if @issue.update(issue_params)
      redirect_to @issue, notice: t('.notice')
    else
      render 'edit'
    end
  end

  # POST /issues
  def create
    @issue.company_id = 1
    @issue.project_id = 1
    @issue.creator_id = current_user.id
    @issue.parent_issue_id = 1
    if @issue.save
      redirect_to @issue, notice: t('.notice')
    else
      render 'new'
    end
  end

  # DELETE /issues/:id
  def destroy
    @issue.destroy
    redirect_to issues_path, notice: t('.notice')
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
