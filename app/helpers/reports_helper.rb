module ReportsHelper
  BADGES = ['success', 'warning', 'danger']

  def issue_priority(issue)
    Issue::PRIORITY.key(issue.priority)
  end

  def attribut_title_from_key(key)
    if key == 'assignee_id'
      label = 'Assignee'
    else
      label = key.titleize
    end
    label
  end

  def assignee_id_key?(key)
    key == 'assignee_id'
  end

  def display_user_name(id)
    current_tanant.users.find(id).name
  end

  def badge_class_from_priority(priority)
    BADGES[priority]
  end
end
