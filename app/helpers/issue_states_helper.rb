module IssueStatesHelper
  def issue_state_table_row_id(issue_state)
    "issue_state_#{issue_state.id}"
  end

  def issue_state_table_row_class(issue_state)
    issue_state.issue_id.nil? ? 'global' : "issue-#{issue_state.issue_id}"
  end

  def issue_state_issues_count(issues_count, issue_state)
    if issues_count.nil?
      result = issue_state.issues.count
    else
      result = issues_count.key?(issue_state.id) ? issues_count[issue_state.id] : 0
    end
    result
  end
end
