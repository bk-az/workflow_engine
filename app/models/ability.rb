# frozen_string_literal: true
class Ability
  include CanCan::Ability

  def initialize(user)
    # user ||= User.new

    if user.present?
      if user.admin?
        can :manage, :all
      else
        can :show, Project do |project|
          project.visible?(user)
        end
        can :index, Project, id: user.visible_projects.pluck(:id)
      end
    end
  end
end
