class UsersCustomController < ApplicationController
  before_action :authenticate_user!

  def set_invitation_view_variables
    # Get logged in User
    @user      = current_user

    # Get companies that are owned by the logged in user.
    @companies = Company.where(owner_id: @user.id)

    # Get Roles
    @roles     = Role.all
  end

  def invite
    set_invitation_view_variables

    # Make a dummy new user.
    @new_user = User.new
  end

  def invite_create
    # Generate Custom Password and treat user an invited member.
    new_user_params = invite_create_params

    # Create a new user.
    @new_user = User.new(new_user_params)
    @new_user.password = generate_password

    # Check if company id is present.
    if new_user_params[:company_id].present?
      # Make sure that provided company id belongs to the set of companies that are owned by logged in user.
      if current_user.company_id_valid?(new_user_params[:company_id])
        redirect_to new_user_invite_path, flash: { failure_notification: "Error 403 Forbidden. You tried to access Company you don't own." }
        return
      end

      if @new_user.save
        # Find Company from database based upon the company id of new user.
        @new_user.send_invitation_email(Company.find(@new_user.company_id), Role.find(@new_user.role_id))
        redirect_to new_user_invite_path, flash: { success_notification: "We have invited '#{@new_user.first_name}' successfully through an email." }
        return
      end
    else
      @new_user.errors[:company_id] = 'ID can never be empty. If you have not created a company yet. Navigate to the create company page and create company first.'
    end

    set_invitation_view_variables
    render 'users_custom/invite'
  end

  private

  def invite_create_params
    params.require(:user).permit(:first_name, :last_name, :company_id, :role_id, :designation, :email)
  end

  def generate_password
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    (0...10).map { o[rand(o.length)] }.join
  end
end
