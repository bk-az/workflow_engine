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
    @issue_state = IssueState.update(params[:id], issue_state_params)
    if @issue_state.valid?
      flash.now[:success] = t('.updated')
    else
      flash.now[:danger] = t('.not_updated')
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @issue_state = IssueState.find(params[:id])
    @total_issues = @issue_state.issues.count
    if @total_issues > 0
      flash.now[:danger] = "#{@total_issues} issue".pluralize(@total_issues) + " using this state"
    else
      @issue_state.destroy
      flash.now[:success] = t('.notice')
    end
    respond_to do |format|
      format.js
    end
  end

  def issue_state_params
    result = params.require(:issue_state).permit(:name, :issue_id)
    result[:issue_id] = params[:issue_id] if params[:issue_id].present?
    result
  end
end
