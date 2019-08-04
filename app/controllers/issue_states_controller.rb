class IssueStatesController < ApplicationController
  autocomplete :issue, :title
  authorize_resource

  def index
    @issue_states = IssueState.load_issue_states(params[:issue_id])
    @issue_state = IssueState.new
    respond_to do |format|
      format.html
    end
  end

  def show
    @issue_state = IssueState.find(params[:id])
    @issue = @issue_state.issue if @issue_state.issue_id
    @total_issues = @issue_state.issues.count
    respond_to do |format|
      format.js
    end
  end

  def create
    @issue_state = IssueState.new(issue_state_params)
    if @issue_state.save
      flash.now[:success] = t('.created')
    else
      flash.now[:danger] = t('.not_created')
    end
    respond_to do |format|
      format.js
    end
  end

  def edit
    @issue_state = IssueState.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @issue_state = IssueState.safe_update(params[:id], issue_state_params)
    if @issue_state.errors.any?
      flash.now[:danger] = t('.not_updated')
    else
      flash.now[:success] = t('.updated')
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @issue_state = IssueState.safe_destroy(params[:id])
    if @issue_state.errors.any?
      flash.now[:danger] = t('.not_deleted')
    else
      flash.now[:success] = t('.deleted')
    end
    respond_to do |format|
      format.js
    end
  end

  def issue_state_params
    result = params.require(:issue_state).permit(:name, :issue_id)
    result[:issue_id] = params[:issue_id] if params[:issue_id].present? && params[:category] == 'issue'
    result
  end
end
