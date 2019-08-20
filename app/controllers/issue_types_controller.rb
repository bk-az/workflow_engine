class IssueTypesController < ApplicationController
  before_action :authenticate_user!
  autocomplete :project, :title
  load_resource :project, except: :destroy
  load_and_authorize_resource

  # GET /issue_types
  # GET /projects/:project_id/issue_types
  def index
    @issues_count = current_tenant.issues.group(:issue_type_id).count
    @issue_types = @issue_types.project_issue_types(params[:project_id]) if params[:project_id].present?
    respond_to do |format|
      format.html
    end
  end

  # GET /projects/:project_id/issue_types/new
  # GET /issue_types/new
  def new
    respond_to do |format|
      format.js
    end
  end

  # POST /projects/:project_id/issue_types
  # POST /issue_types
  def create
    if @issue_type.save
      flash.now[:success] = t('.success')
    else
      flash.now[:danger] = t('.failure')
    end
    respond_to do |format|
      format.js
    end
  end

  # GET /projects/:project_id/issue_types/:id/edit
  # GET /issue_types/:id/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # PATCH /projects/:project_id/issue_types/:id
  # PATCH /issue_types/:id
  def update
    orphan_issues_count = issue_type_params[:project_id].present? ? @issue_type.orphan_issues_count(issue_type_params[:project_id]) : 0
    if orphan_issues_count > 0
      flash.now[:danger] = t('.cannot_update_scope', count: orphan_issues_count)
    elsif @issue_type.update(issue_type_params)
      flash.now[:success] = t('.success')
    else
      flash.now[:danger] = @issue_type.errors.full_messages
      flash.now[:danger] << t('.failure')
    end
    respond_to do |format|
      format.js
    end
  end

  # DELETE /issue_types/:id
  def destroy
    if @issue_type.dependent_issues_present?
      flash.now[:danger] = t('.dependent_issues', count: @issue_type.issues.size)
    else
      @issue_type.destroy
      if @issue_type.destroyed?
        flash.now[:success] = t('.success')
      else
        flash.now[:danger] = t('.failure')
      end
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def issue_type_params
    result = params.require(:issue_type).permit(:name, :project_id)
    if params[:project_id].present?
      result[:project_id] = nil if params[:category] == 'global'
    end
    result
  end
end
