module IssueStatesHelper
  def issue_state_table_row_id(issue_state)
    "issue_state_#{issue_state.id}"
  end

  def issue_state_table_row_class(issue_state)
    issue_state.issue_id.nil? ? 'global' : "issue-#{issue_state.issue_id}"
  end
end
