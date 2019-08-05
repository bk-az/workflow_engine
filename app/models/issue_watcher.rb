class IssueWatcher < ActiveRecord::Base
  belongs_to :watcher, polymorphic: true
  belongs_to :issue

  # Adds watcher to database
  def self.add_watcher(params)
    issue = Issue.find(params[:issue_id])
    watcher_type = params[:watcher_type]
    begin
      if watcher_type == 'User'
        user = User.find(params[:watcher_id])
        user.watching_issues << issue
        return issue, user
      elsif watcher_type == 'Team'
        team = Team.find(params[:watcher_id])
        team.watching_issues << issue
        return issue, team
      end
    rescue ActiveRecord::RecordNotUnique
      return issue
    end
  end

  # Removes watcher from database
  def self.remove_watcher(params)
    issue = Issue.find(params[:issue_id])
    issue_watcher = issue.issue_watchers
                         .find_by(watcher_id: params[:watcher_id],
                                  watcher_type: params[:watcher_type])
    unless issue_watcher.nil?
      issue_watcher.destroy
      watcher_type = params[:watcher_type]
      if watcher_type == 'User'
        user = User.find(params[:watcher_id])
        return issue, user
      elsif watcher_type == 'Team'
        team = Team.find(params[:watcher_id])
        return issue, team
      end
    end
  end

  # Returns all searched watchers to add
  def self.get_watchers_to_add(params)
    issue = Issue.find(params[:issue_id])
    watcher_type = params[:watcher_type]
    keyword = params[:watcher_search]
    if watcher_type == 'User'
      watchers = User.where('first_name LIKE ?', "%#{sanitize_sql_like(keyword)}%")
                     .where.not(id: issue.watcher_users.ids)
    elsif watcher_type == 'Team'
      watchers = Team.where('name LIKE ?', "%#{sanitize_sql_like(keyword)}%")
                     .where.not(id: issue.watcher_teams.ids)
    end
    watchers
  end

  # Returns all searched watchers to remove
  def self.get_watchers_to_remove(params)
    issue = Issue.find(params[:issue_id])
    watcher_type = params[:watcher_type]
    keyword = params[:watcher_search]
    if watcher_type == 'User'
      watchers = User.where('first_name LIKE ?', "%#{sanitize_sql_like(keyword)}%")
                     .where(id: issue.watcher_users.ids)
    elsif watcher_type == 'Team'
      watchers = Team.where('name LIKE ?', "%#{sanitize_sql_like(keyword)}%")
                     .where(id: issue.watcher_teams.ids)
    end
    watchers
  end
end
