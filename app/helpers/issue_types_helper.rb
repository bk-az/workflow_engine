module IssueTypesHelper
  def issue_type_table_row_id(issue_type)
    "issue_type_#{issue_type.id}"
  end

  def issue_type_table_row_class(issue_type)
    issue_type.project_id.nil? ? 'global' : "project-#{issue_type.project_id}"
  end

  def issues_count_helper(issues_count, issue_type)
    if issues_count.nil?
      result = issue_type.issues.count
    else
      result = issues_count.key?(issue_type.id) ? issues_count[issue_type.id] : 0
    end
    result
  end
end
