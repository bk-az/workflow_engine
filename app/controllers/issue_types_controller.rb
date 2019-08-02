class IssueTypesController < ApplicationController
  autocomplete :project, :title
  authorize_resource

  def index
    @issue_types = IssueType.load_issue_types(params[:project_id])
    @issue_type = IssueType.new
    respond_to do |format|
      format.html
    end
  end

  def show
    @issue_type = IssueType.find(params[:id])
    @project = @issue_type.project if @issue_type.project_id
    @total_issues = @issue_type.issues.count
    respond_to do |format|
      format.js
    end
  end

  def create
    @issue_type = IssueType.new(issue_type_params)
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
    @issue_type = IssueType.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @issue_type = IssueType.update(params[:id], issue_type_params)
    if @issue_type.valid?
      flash.now[:success] = t('.updated')
    else
      flash.now[:danger] = t('.not_updated')
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @issue_type = IssueType.find(params[:id])
    @total_issues = @issue_type.issues.count
    if @total_issues > 0
      flash.now[:danger] = "#{@total_issues} issue".pluralize(@total_issues) + " using this type"
    else
      @issue_type.destroy
      flash.now[:success] = t('.notice')
    end
    respond_to do |format|
      format.js
    end
  end

  def issue_type_params
    result = params.require(:issue_type).permit(:name, :project_id)
    result[:project_id] = params[:project_id] if params[:project_id].present?
    result
  end
end
