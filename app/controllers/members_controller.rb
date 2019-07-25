class MembersController < ApplicationController
  before_action :authenticate_user!

  # GET /members/invite
  def invite
    set_invitation_view_variables

    # Make a dummy new user.
    @new_user = User.new
  end

  # POST /members/invite
  def invite_create
    # Generate Custom Password and treat user an invited member.
    new_user_params = invite_create_params

    # Create a new user.
    @new_user = User.new(new_user_params)
    @new_user.is_invited_user = true

    # Set company_id to the id of company which is acting as current tenant.
    @new_user.company_id = current_tenant.id
    @new_user.password = generate_random_password

    if @new_user.save
      # Find Company from database based upon the company id of new user.
      @new_user.send_invitation_email(@new_user.company, @new_user.role)
      redirect_to member_invite_path, flash: { success_notification: "We have invited '#{@new_user.first_name}' successfully through an email." }
      return
    end

    set_invitation_view_variables
    render 'members/invite'
  end

  # GET /members/privileges
  def privileges
    # Get logged in User
    @user = current_user

    # Get Company
    @company = current_tenant

    # Get all users that belong to company which is owned by current user.
    # Exlude the logged in user himself.
    @members = @company.users.includes(:role).where.not(id: @user.id)

    @roles = Role.all
  end

  # GET /members/privileges/:id
  def privileges_show
    user_id = privileges_show_params[:id]
    render json: { data: { user: current_tenant.users.find(user_id) } }
  end

  # POST /members/privileges/edit
  def privileges_update
    user_id = privileges_update_params[:user_id]
    new_role_id = privileges_update_params[:role_id]

    user = current_tenant.users.find(user_id)
    if user.update(role_id: new_role_id)
      render json: { data: { status: true, role_name: user.role.name } }
    else
      render json: { data: { status: false, role_name: '' } }
    end
  end

  # GET /members
  def index
    @company = current_tenant
    # Get members other the logged in user.
    @members = @company.users.includes(:role).where.not(id: current_user.id)
  end

  # GET /members/:id
  def show
    @company = current_tenant
    @member = @company.users.where(id: params[:id]).first
  end

  # GET /members/edit/:id
  def edit
    @company = current_tenant
    @member = @company.users.find(params[:id])
    @roles = Role.all
  end

  # PUT /members/edit
  def update
    @company = current_tenant
    @member = @company.users.find(update_params[:id])
    @roles = Role.all
    if @member.update(update_params)
      redirect_to member_edit_path(@member), flash: { success_notification: 'Details Updated Successfully!' }
    else
      render 'members/edit'
    end
  end

  # DELETE /members/delete/:id
  def delete
    member_to_be_deleted = current_tenant.users.find(params[:id])
    if member_to_be_deleted.destroy
      redirect_to members_path, flash: { success_notification: 'Member Deleted Successfully!' }
    else
      redirect_to members_path, flash: { failure_notification: member_to_be_deleted.errors[:base].join }
    end
  end

  private

  def set_invitation_view_variables
    # Get logged in User
    @user      = current_user

    # Get Roles
    @roles     = Role.all

    # Get Current Company
    @company = current_tenant
  end

  def invite_create_params
    params.require(:user).permit(:first_name, :last_name, :email, :role_id, :designation)
  end

  def privileges_show_params
    params.permit(:id)
  end

  def privileges_update_params
    params.permit(:user_id, :role_id)
  end

  def update_params
    params.require(:user).permit(:id, :first_name, :last_name, :role_id)
  end

  def generate_random_password
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    (0...10).map { o[rand(o.length)] }.join
  end
end
