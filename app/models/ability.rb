# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      if user.role.name == 'Administrator'
        can :manage, :all
      else
        can :read, Project do |p|
          ProjectMembership.where(project_id: p.id, project_member_id: user.id,
                                  project_member_type: 'User').present?
        end
      end
    end
  end

  def admin
    can :manage, :all
  end
end
