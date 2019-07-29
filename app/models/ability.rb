# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, options = {})
    if user.present?
      if user.admin?
        can :manage, :all
      elsif ProjectMembership.where(project_id: options[:project_id], project_member_id: user.id, project_member_type: 'User').ids.present?
        can :index, ProjectMembership
      end
    end
  end
end
