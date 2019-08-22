class IssueWatcher < ActiveRecord::Base
  belongs_to :issue
  belongs_to :company
  belongs_to :watcher, polymorphic: true

  validates :issue_id, presence: true
  validates :watcher_id, presence: true
  validates :watcher_type, presence: true

  WATCHER_TYPES = { user: 'User', team: 'Team' }.freeze
  WATCHER_ACTION = { create: 'create', destroy: 'destroy' }.freeze

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
