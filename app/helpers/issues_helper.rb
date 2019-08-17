# issues_helper.rb
module IssuesHelper
  BADGES = ['success', 'warning', 'danger'].freeze
  KEY_TO_CLASS_MAPPINGS = { assignee_id: User,
                            issue_state_id: IssueState,
                            issue_type_id: IssueType }.freeze

  def get_priority(priority)
    Issue::PRIORITY.key(priority)
  end

  def show_priority
    Issue::PRIORITY
  end

  def get_readable_information(key, value)
    if value.blank?
      result = 'NULL'
    elsif KEY_TO_CLASS_MAPPINGS.keys.include?(key.to_sym)
      result = KEY_TO_CLASS_MAPPINGS[key.to_sym].find(value).name
    elsif key == 'progress'
      result = number_to_percentage(value, precision: 0)
    elsif key == 'priority'
      result = get_priority(value)
    else
      result = value
    end
    result
  end

  def badge_class_from_priority(priority)
    BADGES[priority]
  end
end
