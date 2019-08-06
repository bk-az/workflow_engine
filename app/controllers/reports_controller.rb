class ReportsController < ApplicationController
  authorize_resource class: false

  def issues
    @issues = Issue.includes(:project, :assignee, :creator, :issue_state, :issue_type).all
    respond_to do |format|
      format.html
    end
  end
end
