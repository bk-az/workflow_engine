# frozen_string_literal: true
class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can :manage, IssueState if user.admin?
  end
end
