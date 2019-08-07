# frozen_string_literal: true
class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    if user.admin?
      can :manage, :all
    else
      can [:read, :filter], Issue, user.visible_issues do |issue|
        issue
      end
      can :show, Project do |project|
        project.visible?(user)
      end
      can :index, Project, id: user.visible_projects.pluck(:id)

      can :update, Issue do |issue|
        (issue.assignee_id == user.id || issue.creator_id == user.id) &&
          issue.company_id == user.company_id
      end
      can :destroy, Issue do |issue|
        issue.creator_id == user.id && issue.company_id == user.company_id
      end
      can :create, Issue, company_id: user.company_id

      # IssueWatcher
      can :create_watcher, IssueWatcher, watcher_id: user.id, watcher_type: IssueWatcher::WATCHER_TYPE_USER
      can :destroy_watcher, IssueWatcher, watcher_id: user.id, watcher_type: IssueWatcher::WATCHER_TYPE_USER
    end
  end
end
