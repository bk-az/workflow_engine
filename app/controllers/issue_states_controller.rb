class IssueStatesController < ApplicationController
  before_action :authenticate_user!
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
    @issue_state.update(issue_state_params)
    if @issue_state.errors.blank?
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

  def issues
    @issues = @issue_state.issues
    respond_to do |format|
      format.js
    end
  end

  def issue_state_params
    params.require(:issue_state).permit(:name)
  end
end
