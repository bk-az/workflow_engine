class IssueTypesController < ApplicationController
  before_action :authenticate_user!
  autocomplete :project, :title
  load_resource :project, except: :destroy
  load_and_authorize_resource

  def index
    @issue_types = @issue_types.project_issue_types(params[:project_id]) if params[:project_id].present?
    # required for new_issue_type_modal
    @issue_type = IssueType.new
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
    if @issue_type.save
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
    if @issue_type.can_change_scope?(issue_type_params[:project_id])
      @issue_type.update(issue_type_params)
      flash.now[:success] = t('.updated') if @issue_type.errors.blank?
    else
      flash.now[:danger] = t('.not_updated')
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    if @issue_type.dependent_issues_present?
      flash.now[:danger] = t('.not_deleted')
    else
      @issue_type.destroy
      flash.now[:success] = t('.deleted')
    end
    respond_to do |format|
      format.js
    end
  end

  def issues
    @issues = @issue_type.issues
    respond_to do |format|
      format.js
    end
  end

  def issue_type_params
    result = params.require(:issue_type).permit(:name, :project_id)
    if params[:project_id].present?
      result[:project_id] = nil if params[:category] == 'global'
    end
    result
  end
end
