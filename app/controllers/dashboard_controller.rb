class DashboardController < ApplicationController
  authorize_resource class: false
  add_breadcrumb 'My Workplace', :dashboard_path

  def index
    @projects = current_tenant.projects.accessible_by(current_ability)
    @assigned_issues = current_user.assigned_issues
    @watching_issues = current_user.watching_issues
    if @projects.count > 0
      @project = @projects.first
      @issues = @project.issues
    end
    @timeline_data = @assigned_issues.order(:start_date).pluck(:title, :start_date, :due_date)
    @watching_issues_pie_chart_data = @watching_issues.group_by_issue_state.count
    @assigned_issues_pie_chart_data = @assigned_issues.group_by_issue_state.count
    respond_to do |format|
      format.html
    end
  end

  def issues
    @project = current_tenant.projects.accessible_by(current_ability).includes(issues: :issue_state).find(params[:project_id])
    @issues = @project.issues
    respond_to do |format|
      format.js
    end
  end
end
