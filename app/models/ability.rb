# frozen_string_literal: true
class Ability
  include CanCan::Ability
  def initialize(user, options = {})
    return if user.nil?

    can [:show_change_password_form, :change_password], :member if options[:change_password_member_id] == user.id
    can [:index, :show], :member

    if user.admin?
      can :manage, :all
      can [:new, :create, :privileges, :privileges_show, :edit, :destroy, :update], :member
    else
      # Project
      can :show, Project do |project|
        project.visible?(user)
      end
      can :index, Project, id: user.visible_projects.pluck(:id)

      # Team
      can :read, Team
      can :add_membership, Team

      # Project Membership
      can :index, ProjectMembership if ProjectMembership.user_projects(user, options[:project_id]).present?

      # Issue
      can [:read, :filter], Issue, user.visible_issues do |issue|
        issue
      end
      can :update, Issue do |issue|
        (issue.assignee_id == user.id || issue.creator_id == user.id) &&
          issue.company_id == user.company_id
      end
      can :destroy, Issue do |issue|
        issue.creator_id == user.id && issue.company_id == user.company_id
      end
      can :create, Issue, company_id: user.company_id

      # IssueWatcher
      can :create_watcher, IssueWatcher, company_id: user.company_id, watcher_id: user.id, watcher_type: IssueWatcher::WATCHER_TYPE_USER
      can :destroy_watcher, IssueWatcher, company_id: user.company_id, watcher_id: user.id, watcher_type: IssueWatcher::WATCHER_TYPE_USER

      # Document
      can [:create, :index, :destroy], Document, company_id: user.company_id

      # Dashboard
      can :manage, :dashboard
    end
  end
end
