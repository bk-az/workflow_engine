module IssueTypesHelper
  def issue_type_table_row_id(issue_type)
    "issue_type_#{issue_type.id}"
  end

  def issue_type_table_row_class(issue_type)
    issue_type.project_id.nil? ? 'global' : "project-#{issue_type.project_id}"
  end

  def issue_type_project_number(issue_type)
    issue_type.project_id.nil? ? 'NA' : link_to(project_path(issue_type.project_id)) {'<i class="fas fa-external-link-square-alt"></i>'}
  end
end
