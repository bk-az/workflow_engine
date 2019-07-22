class IssuesController < ApplicationController
  def index
    @issues = Issue.order(:project_id).page(params[:page])
  end

  def filter
    @issues = Issue.where(search_params).page(params[:page])
    @issues = @issues.where('title like ?', "%#{params[:search_filter]}%")
    respond_to do |format|
      format.js
    end
  end

  private

  def search_params
    params.
      # Optionally, whitelist your search parameters with permit
      permit(:project_id, :assignee_id, :issue_state_id, :issue_type_id).
      # Delete any passed params that are nil or empty string
      delete_if { |key, value| value.blank? }
  end
end
