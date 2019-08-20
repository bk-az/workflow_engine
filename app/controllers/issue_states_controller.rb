class IssueStatesController < ApplicationController
  before_action :authenticate_user!
  add_breadcrumb 'Issue States', :issue_states_path
  load_and_authorize_resource

  def index
    @issues_count = current_tenant.issues.group(:issue_state_id).count
    respond_to do |format|
      format.html
    end
  end

  def new
    respond_to do |format|
      format.js
    end
  end

  def create
    if @issue_state.save
      flash.now[:success] = t('.success')
    else
      flash.now[:danger] = t('.failure')
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
    @issue_state.update(issue_state_params)
    if @issue_state.errors.blank?
      flash.now[:success] = t('.success')
    else
      flash.now[:danger] = t('.failure')
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    if @issue_state.dependent_issues_present?
      flash.now[:danger] = t('.failure')
    else
      @issue_state.destroy
      flash.now[:success] = t('.success')
    end
    respond_to do |format|
      format.js
    end
  end

  def issue_state_params
    params.require(:issue_state).permit(:name)
  end
end
