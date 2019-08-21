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

  def get_associated_information(key, value)
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

  def issue_delete_data_confirm(issue)
    watchers_count = issue.issue_watchers.count
    if watchers_count.zero?
      t('issues.confirm_delete.default')
    else
      t('issues.confirm_delete.watchers_exist_warning', watchers_count: watchers_count).pluralize(watchers_count)
    end
  end
end
