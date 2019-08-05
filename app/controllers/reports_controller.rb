class ReportsController < ApplicationController
  def issues
    @issues = Issue.includes(:project, :assignee, :creator, :issue_state, :issue_type).all
    respond_to do |format|
      format.html
    end
  end
end

#   respond_to do |format|
#   format.html
#   format.pdf {render pdf: 'ProjectReport', template: 'projects/project_report'}
# end
