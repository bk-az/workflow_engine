# Issues Controller
class IssuesController < ApplicationController
  # Shows all issues page by page
  def index
    @issues = Issue.order(:project_id).page(params[:page])
  end

  # Filters rows of issues
  def filter
    @issues = Issue.where(search_params).page(params[:page])
    @issues = @issues.where('title like ?', "%#{params[:search_filter]}%")
    respond_to do |format|
      format.js
    end
  end

  # Creates instance of new issue
  def new
    @issue = Issue.new
  end

  # Shows details of particular issue
  def show
    @issue = Issue.find(params[:id])
  end

  # Shows edit page particular issue
  def edit
    @issue = Issue.find(params[:id])
  end

  # Updates particular issue
  def update
    @issue = Issue.find(params[:id])
    if @issue.update(issue_params)
      flash[:update_issue] = 'Issue Updated successfully!'
      redirect_to @issue
    else
      render 'edit'
    end
  end

  # Creates new issue
  def create
    @issue = Issue.new(issue_params)
    @issue.company_id, @issue.project_id = 1
    # @issue.project_id = 1
    @issue.creator_id = 2
    @issue.parent_issue_id = 1
    if @issue.save
      flash[:save_issue] = 'Issue Created successfully!'
      redirect_to @issue # redirect to show page
    else
      render 'new'
    end
  end

  # Destroys particular issue
  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy
    flash[:destroy_issue] = 'Issue Deleted successfully'
    redirect_to issues_path
  end

  private

  # Permits columns while adding to database
  def issue_params
    params.require(:issue).permit(:title, :description, :start_date, :due_date,
                                  :progress, :priority, :company_id,
                                  :creator_id, :assignee_id,
                                  :parent_issue_id, :project_id,
                                  :issue_state_id, :issue_type_id)
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
