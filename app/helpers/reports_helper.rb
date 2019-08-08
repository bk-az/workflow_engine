module ReportsHelper
  def issue_priority(issue)
    Issue::PRIORITY.key(issue.priority)
  end
end
