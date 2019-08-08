class ReportsController < ApplicationController
  authorize_resource class: false

  def issues
    @issues = current_tenant.issues.includes(:project, :assignee, :creator, :issue_state, :issue_type)
    respond_to do |format|
      format.html
    end
  end
end
