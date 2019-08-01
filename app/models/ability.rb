# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, options = {})
    if user.present?
      if user.admin?
        can :manage, :all
      else # a member can only read memberships if she/he is a member of project
        can :index, ProjectMembership if ProjectMembership.user_projects(user, options[:project_id]).present?
      end
    end
  end
end
