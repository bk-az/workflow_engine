class IssueWatcher < ActiveRecord::Base
  belongs_to :issue
  belongs_to :company
  belongs_to :watcher, polymorphic: true

  WATCHER_TYPES = {user: 'User', team: 'Team'}.freeze

  # Adds watcher to database
  def self.add_watcher(params)
    issue = Issue.find_by(id: params[:issue_id])
    begin
      if issue.present?
        if params[:watcher_type] == WATCHER_TYPES[:user]
          user = User.find_by(id: params[:watcher_id])
          if user.present?
            user.watching_issues << issue
            return issue, user
          end
        elsif params[:watcher_type] == WATCHER_TYPES[:team]
          team = Team.find_by(id: params[:watcher_id])
          if team.present?
            team.watching_issues << issue
            return issue, team
          end
        end
      end
    rescue ActiveRecord::RecordNotUnique
      return issue
    end
  end

  # Removes watcher from database
  def self.remove_watcher(params)
    issue = Issue.find_by(id: params[:issue_id])
    if issue.present?
      issue_watcher = issue.issue_watchers.find_by(watcher_id: params[:watcher_id], watcher_type: params[:watcher_type])
    end

    if issue_watcher.present?
      issue_watcher.destroy
      if params[:watcher_type] == WATCHER_TYPES[:user]
        user = User.find_by(id: params[:watcher_id])
        return issue, user
      elsif params[:watcher_type] == WATCHER_TYPES[:team]
        team = Team.find_by(id: params[:watcher_id])
        return issue, team
      end
    end
  end

  # Returns all searched watchers to add
  def self.get_watchers_to_add(params)
    issue = Issue.find_by(id: params[:issue_id])
    if issue.present?
      if params[:watcher_type] == WATCHER_TYPES[:user]
        watchers = User.where('first_name LIKE ?', "%#{sanitize_sql_like(params[:watcher_search])}%")
                       .where.not(id: issue.watcher_users.ids)
      elsif params[:watcher_type] == WATCHER_TYPES[:team]
        watchers = Team.where('name LIKE ?', "%#{sanitize_sql_like(params[:watcher_search])}%")
                       .where.not(id: issue.watcher_teams.ids)
      end
    end
    watchers
  end

  # Returns all searched watchers to remove
  def self.get_watchers_to_remove(params)
    issue = Issue.find_by(id: params[:issue_id])
    if issue.present?
      if params[:watcher_type] == WATCHER_TYPES[:user]
        watchers = User.where('first_name LIKE ?', "%#{sanitize_sql_like(params[:watcher_search])}%")
                       .where(id: issue.watcher_users.ids)
      elsif params[:watcher_type] == WATCHER_TYPES[:team]
        watchers = Team.where('name LIKE ?', "%#{sanitize_sql_like(params[:watcher_search])}%")
                       .where(id: issue.watcher_teams.ids)
      end
    end
    watchers
  end
end
