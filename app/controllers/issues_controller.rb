class IssuesController < ApplicationController

  def index
    # @issues = Project.find(params[:project_id]).issues.all
    @issues = Issue.all
  end

  def new
    @issue = Issue.new
  end

  def show
     @issue = Issue.find(params[:id])
  end


  def edit
     @issue = Issue.find(params[:id])
  end

  def update
    @issue = Issue.find(params[:id])
    if(@issue.update(issue_params))
      flash[:update_issue] = "Issue Updated successfully!"
      redirect_to @issue
    else
      render 'edit'
    end
  end

  def create
    #render plain: params[:user].inspect
    @issue = Issue.new(issue_params)
    @issue.company_id = 1
    @issue.project_id = 1
    @issue.creator_id = 2
    # @issue.assignee_id = 2
    @issue.parent_issue_id = 1
    # @issue.issue_state_id = 2
    # @issue.issue_type_id = 2
    if(@issue.save)
      flash[:save_issue] = "Issue Created successfully!"
      redirect_to @issue  ## redirect to show page 
    else
      render 'new'
    end
  end


  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy
    flash[:destroy_issue] = "Issue Deleted successfully"
    redirect_to issues_path
  end

  private def issue_params
    params.require(:issue).permit(:title,:description, :start_date, :due_date, :progress, :priority,
      :company_id, :creator_id, :assignee_id, :parent_issue_id,:project_id,:issue_state_id,:issue_type_id)


  end
end
