class IssueWatcher < ActiveRecord::Base
  include ActiveRecord::UnionScope

  scope :issues_directly_watched_by_user, -> (user_id) do
    select("issues.sequence_num AS issue_id,
      issues.title as issue_title,
      issue_watchers.watcher_id as watcher_id,
      'Direct' as through")
      .joins('INNER JOIN issues ON issue_watchers.issue_id = issues.id')
      .where(watcher_type: WATCHER_TYPES[:user])
      .where(watcher_id: user_id)
  end

  scope :issues_watched_by_user_through_teams, -> (user_id) do
    select("issues.sequence_num AS issue_id,
      issues.title as issue_title,
      issue_watchers.watcher_id as watcher_id,
      teams.name as through")
      .joins('INNER JOIN issues ON issue_watchers.issue_id = issues.id')
      .joins('INNER JOIN teams ON issue_watchers.watcher_id = teams.id')
      .joins('INNER JOIN team_memberships ON teams.id = team_memberships.team_id')
      .where(watcher_type: WATCHER_TYPES[:team])
      .where('team_memberships.user_id = :user_id', user_id: user_id)
  end

  scope :issues_watched_by_user_with_through, -> (user_id) do
    find_by_sql(union_scope(issues_directly_watched_by_user(user_id), issues_watched_by_user_through_teams(user_id)))
  end

  belongs_to :issue
  belongs_to :company
  belongs_to :watcher, polymorphic: true

  WATCHER_TYPES = { user: 'User', team: 'Team' }.freeze
  WATCHER_ACTION = { create: 'create', destroy: 'destroy' }.freeze

  # Adds watcher to database
  def add(params)
    issue = company.issues.find_by(id: params[:issue_id])
    begin
      if issue.present?
        if params[:watcher_type] == WATCHER_TYPES[:user]
          user = company.users.find_by(id: params[:watcher_id])
          if user.present?
            user.watching_issues << issue
            return issue, user
          end
        elsif params[:watcher_type] == WATCHER_TYPES[:team]
          team = company.teams.find_by(id: params[:watcher_id])
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
  def remove(issue_watcher)
    if issue_watcher.present?
      issue_watcher.destroy
      if issue_watcher.watcher_type == WATCHER_TYPES[:user]
        user = company.users.find_by(id: issue_watcher.watcher_id)
        return issue, user
      elsif issue_watcher.watcher_type == WATCHER_TYPES[:team]
        team = company.teams.find_by(id: issue_watcher.watcher_id)
        return issue, team
      end
    end
  end

  # Returns watchers
  def self.find_watchers(params, current_tenant)
    issue = current_tenant.issues.find_by(id: params[:issue_id])
    if issue.present?
      if params[:watcher_type] == WATCHER_TYPES[:user]
        watchers = current_tenant.users.where('first_name LIKE ?', "%#{sanitize_sql_like(params[:watcher_search])}%")
        if params[:watcher_action] == WATCHER_ACTION[:create]
          watchers = watchers.where.not(id: issue.watcher_users.ids)
        elsif params[:watcher_action] == WATCHER_ACTION[:destroy]
          watchers = watchers.where(id: issue.watcher_users.ids)
        end
      elsif params[:watcher_type] == WATCHER_TYPES[:team]
        watchers = current_tenant.teams.where('name LIKE ?', "%#{sanitize_sql_like(params[:watcher_search])}%")
                                 .where.not(id: issue.watcher_teams.ids)
        if params[:watcher_action] == WATCHER_ACTION[:create]
          watchers = watchers.where.not(id: issue.watcher_teams.ids)
        elsif params[:watcher_action] == WATCHER_ACTION[:destroy]
          watchers = watchers.where(id: issue.watcher_teams.ids)
        end
      end
    end
    watchers
  end
end
