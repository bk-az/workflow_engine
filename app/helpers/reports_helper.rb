module ReportsHelper
  def issue_priority(issue)
    Issue::PRIORITY.key(issue.priority)
  end

  def assignee_id_key?(key)
    key == 'assignee_id'
  end

  def display_user_name(id)
    User.find(id).name
  end
end
