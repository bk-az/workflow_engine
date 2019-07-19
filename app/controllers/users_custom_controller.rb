class UsersCustomController < ApplicationController
  before_action :authenticate_user!

  def invite
    # Get logged in User
    @user      = current_user

    # Get companies that are owned by the logged in user.
    @companies = Company.where(owner_id: @user.id)

    # Get Roles
    @roles     = Role.all
  end
end
