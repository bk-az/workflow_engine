class ReportsController < ApplicationController
  authorize_resource class: false
  add_breadcrumb 'Issues Report', :issues_report_path

  def issues
    @issues = current_tenant.issues.includes(:project, :assignee, :creator, :issue_state, :issue_type)
    respond_to do |format|
      format.html
    end
  end
end
