module IssueWatchersHelper
  def get_issue_watcher(issue, watcher_id, watcher_type)
    issue.issue_watchers.find_by(issue_id: issue.id, watcher_id: watcher_id, watcher_type: watcher_type)
  end
end
