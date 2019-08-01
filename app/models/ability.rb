# frozen_string_literal: true
class Ability
  include CanCan::Ability

  def initialize(user)
    # user ||= User.new

    if user.present?
      if user.admin?
        can :manage, :all
      else
        can :read, Project, Project.visible_projects(user) do |project|
          project
        end
      end
    end
  end
end
