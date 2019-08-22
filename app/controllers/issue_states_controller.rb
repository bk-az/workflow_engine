class IssueStatesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  add_breadcrumb 'Issue States', :issue_states_path

  # GET /issue_states
  def index
    @issues_count = current_tenant.issues.group(:issue_state_id).count
    respond_to do |format|
      format.html
    end
  end

  # GET /issue_states/new
  def new
    respond_to do |format|
      format.js
    end
  end

  # POST /issue_states
  def create
    if @issue_state.save
      flash.now[:success] = t('.success')
    else
      flash.now[:error] = @issue_state.errors.full_messages
      flash.now[:error] << t('.failure')
    end
    respond_to do |format|
      format.js
    end
  end

  # GET /issue_states/:id
  def edit
    respond_to do |format|
      format.js
    end
  end

  # PATCH /issue_states/:id
  def update
    @issue_state.update(issue_state_params)
    if @issue_state.errors.blank?
      flash.now[:success] = t('.success')
    else
      flash.now[:error] = @issue_state.errors.full_messages
      flash.now[:error] << t('.failure')
    end
    respond_to do |format|
      format.js
    end
  end

  # DELETE /issue_states/:id
  def destroy
    if @issue_state.dependent_issues_present?
      flash.now[:error] = t('.dependent_issues', count: @issue_state.issues.size)
    else
      @issue_state.destroy
      if @issue_state.destroyed?
        flash.now[:success] = t('.success')
      else
        flash.now[:error] = t('.failure')
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def issue_state_params
    params.require(:issue_state).permit(:name)
  end
end
