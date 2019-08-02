# frozen_string_literal: true
class Ability
  include CanCan::Ability

  def initialize(user, options = {})
    return unless user.present?

    if user.admin?
      can :manage, Project
      can :manage, ProjectMembership
    else
      can :show, Project do |project|
        project.visible?(user)
      end
      can :index, Project, id: user.visible_projects.pluck(:id)
      can :index, ProjectMembership if ProjectMembership.user_projects(user, options[:project_id]).present?
    end
  end
end
