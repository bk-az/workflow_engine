class IssueStatesController < ApplicationController
  autocomplete :issue, :title, display_value: :title_with_project_id, extra_data: [:project_id]
  load_and_authorize_resource

  def index
    @issue_states = @issue_states.issue_specific_states(params[:issue_id]) unless params[:issue_id].nil?
    # required for new_issue_state_modal
    @issue_state = IssueState.new
    respond_to do |format|
      format.html
    end
  end

  def show
    @issue = @issue_state.issue if @issue_state.issue_id
    @total_issues = @issue_state.issues.count
    respond_to do |format|
      format.js
    end
  end

  def create
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
    respond_to do |format|
      format.js
    end
  end

  def update
    if @issue_state.safe_update?(issue_state_params)
      flash.now[:success] = t('.updated')
    else
      flash.now[:danger] = t('.not_updated')
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    if @issue_state.safe_destroy?
      flash.now[:success] = t('.deleted')
    else
      flash.now[:danger] = t('.not_deleted')
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
