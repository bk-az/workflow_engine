# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, options = {})
    return unless user.present?

    can [:show_change_password_form, :change_password], :member if options[:change_password_member_id] == user.id
    can [:index, :show], :member
    can [:new, :create, :privileges, :privileges_show, :edit, :destroy, :update], :member if user.role_id == Role.admin.id
  end
end
