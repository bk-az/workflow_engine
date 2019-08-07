class IssueStatesController < ApplicationController
  autocomplete :issue, :title, display_value: :title_with_project_id, extra_data: [:project_id]
  load_resource :issue, except: :destroy
  load_and_authorize_resource

  def index
    @issue_states = @issue_states.issue_specific_states(params[:issue_id]) if params[:issue_id].present?
    respond_to do |format|
      format.html
    end
  end

  def show
    @total_issues = @issue_state.issues.count
    respond_to do |format|
      format.js
    end
  end

  def new
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
    if @issue_state.can_change_scope?(issue_state_params[:issue_id])
      @issue_state.update(issue_state_params)
      flash.now[:success] = t('.updated')
    else
      flash.now[:danger] = t('.not_updated')
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    if @issue_state.dependent_issues_present?
      flash.now[:danger] = t('.not_deleted')
    else
      @issue_state.destroy
      flash.now[:success] = t('.deleted')
    end
    respond_to do |format|
      format.js
    end
  end

  def issue_state_params
    result = params.require(:issue_state).permit(:name, :issue_id)
    if params[:issue_id].present?
      result[:issue_id] = nil if params[:category] == 'global'
    end
    result
  end
end
