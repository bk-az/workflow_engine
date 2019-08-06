module ReportsHelper
  def issue_priority(issue)
    issue.priority > 0 ? Issue::PRIORITIES[1] : Issue::PRIORITIES[0]
  end
end
