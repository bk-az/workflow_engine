# Issues Controller
class IssuesController < ApplicationController
  load_and_authorize_resource
  # GET /issues
  def index
    @issues = @issues.order(:project_id).page(params[:page])
    @issue_types = IssueType.all
    @issue_states = IssueState.all
    @projects = current_user.visible_projects
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
    @assignees = User.all
    @issue_types = IssueType.all
    @issue_states = IssueState.all
    respond_to do |format|
      format.html
    end
  end

  # GET /issues/:id
  def show
<<<<<<< HEAD
    @document = Document.new
    @issue = Issue.find(params[:id])

=======
    respond_to do |format|
      format.html
    end
>>>>>>> 3e6d3ddb7129b1d47955ee772c7d72301f13dcfd
  end

  # GET /issues/:id/edit
  def edit
    @assignees = User.all
    @issue_types = IssueType.all   # TODO: current_tenant.issue_types
    @issue_states = IssueState.all # TODO: current_tenant.issue_states
    respond_to do |format|
      format.html
    end
  end

  # PUT /issues/:id
  def update
    if @issue.update(issue_params)
<<<<<<< HEAD
      redirect_to @issue, update_issue: t('.Issue Updated successfully!')
=======
      flash[:notice] = t('.notice')

      respond_to do |format|
        format.html { redirect_to @issue }
      end
>>>>>>> 3e6d3ddb7129b1d47955ee772c7d72301f13dcfd
    else
      flash.now[:error] = @issue.errors.full_messages
      render 'edit'
    end
  end

  # POST /issues
  def create
    @issue.company_id = 1 # TODO: Remove after merge
    @issue.project_id = 1 # TODO: Remove after merge
    @issue.creator_id = current_user.id
    if @issue.save
<<<<<<< HEAD
      redirect_to @issue, save_issue: t('.Issue Created and Saved  successfully!') # redirect to show page
=======
      flash[:notice] = t('.notice')
      respond_to do |format|
        format.html { redirect_to @issue }
      end
>>>>>>> 3e6d3ddb7129b1d47955ee772c7d72301f13dcfd
    else
      flash.now[:error] = @issue.errors.full_messages
      render 'new'
    end
  end

  # DELETE /issues/:id
  def destroy
    @issue.destroy
<<<<<<< HEAD
    redirect_to issues_path,  destroy_issue: t('.Issue Deleted successfully')
=======
    flash[:notice] = t('.notice')
    respond_to do |format|
      format.html { redirect_to issues_path }
    end
>>>>>>> 3e6d3ddb7129b1d47955ee772c7d72301f13dcfd
  end

  private

  # Permits columns while adding to database
  def issue_params
    params.require(:issue)
          .permit(:title, :description, :start_date, :due_date, :progress,
                  :priority, :company_id, :creator_id, :assignee_id,
                  :parent_issue_id, :project_id, :issue_state_id,
                  :issue_type_id)
  end

  def document_params
      params.require(:document).permit(:path, :company_id)
  end

  # Permits columns that are not blank for search
  def search_params
    params.
      # Optionally, whitelist your search parameters with permit
      permit(:project_id, :assignee_id, :issue_state_id, :issue_type_id).
      # Delete any passed params that are nil or empty string
      delete_if { |_key, value| value.blank? }
  end
end
