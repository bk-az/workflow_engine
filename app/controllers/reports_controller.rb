class ReportsController < ApplicationController
  authorize_resource class: false

  def issues
    @issues = Issue.includes(:project, :assignee, :creator, :issue_state, :issue_type).all
    respond_to do |format|
      format.html
    end
  end

  def issue_history
    @issue = Issue.find(params[:issue_id])
    @audits = @issue.audits.map(&:audited_changes).reverse
    respond_to do |format|
      format.html
    end
  end
end
