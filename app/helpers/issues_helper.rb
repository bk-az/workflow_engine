# issues_helper.rb
module IssuesHelper
  BADGES = ['success', 'warning', 'danger']

  def get_priority(priority)
    Issue::PRIORITY.key(priority)
  end

  def show_priority
    Issue::PRIORITY
  end

  def attribute_title_from_key(key)
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
    User.find(id).name
  end

  def badge_class_from_priority(priority)
    BADGES[priority]
  end
end
