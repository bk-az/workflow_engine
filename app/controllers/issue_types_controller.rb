class IssueTypesController < ApplicationController
  autocomplete :project, :title
  load_and_authorize_resource

  def index
    @issue_types = @issue_types.project_issue_types(params[:project_id]) unless params[:project_id].nil?
    # required for new_issue_type_modal
    @issue_type = IssueType.new
    respond_to do |format|
      format.html
    end
  end

  def show
    @project = @issue_type.project if @issue_type.project_id
    @total_issues = @issue_type.issues.count
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
    if @issue_type.safe_update?(issue_type_params)
      flash.now[:success] = t('.updated')
    else
      flash.now[:danger] = t('.not_updated')
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    if @issue_type.safe_destroy?
      flash.now[:success] = t('.deleted')
    else
      flash.now[:danger] = t('.not_deleted')
    end
    respond_to do |format|
      format.js
    end
  end

  def issue_type_params
    result = params.require(:issue_type).permit(:name, :project_id)
    result[:project_id] = params[:project_id] if params[:project_id].present? && params[:category] == 'project'
    result
  end
end
