class MembersController < ApplicationController
  before_action :authenticate_user!
  authorize_resource class: false
  before_action :changed_sys_generated_password?, only: [:show_change_password_form, :change_password]
  add_breadcrumb 'Members', :members_path

  # GET /members/new
  def new
    add_breadcrumb 'New Member', :new_member_path
    set_invitation_view_variables
    # Make a dummy new user.
    @new_user = User.new

    respond_to do |format|
      format.html { render 'members/invite' }
    end
  end

  # POST /members
  def create
    validation_error = false
    # Generate Custom Password and treat user an invited member.
    new_user_params = create_params

    company = current_tenant
    # Generate a new user belonging to the current company.
    @new_user = company.users.new(new_user_params)
    @new_user.has_changed_sys_generated_password = false

    @new_user.password = generate_random_password

    if @new_user.save
      @new_user.send_invitation_email(company, @new_user.role) unless @new_user.skip_invitation_email
      flash[:success] = t('members.create.success')
    else
      flash[:error] = @new_user.errors.full_messages
      validation_error = true
    end

    respond_to do |format|
      format.html do
        if validation_error
          set_invitation_view_variables
          render 'members/invite'
        else
          redirect_to new_member_path
        end
      end
    end
  end

  # GET /members/privileges
  def privileges
    # Get Company
    @company = current_tenant

    # Get all users that belong to company which is owned by current user.
    # Exlude the logged in user himself.
    @members = @company.users.where.not(id: current_user.id).active.includes(:role)
    @roles = Role.all
    add_breadcrumb 'Privileges', :privileges_members_path

    respond_to do |format|
      format.html { render 'members/privileges' }
    end
  end

  # GET /members/privileges/:id
  def privileges_show
    @user = current_tenant.users.where.not(id: current_user.id).active.find(params[:id])
    respond_to do |format|
      format.js { render json: { data: { user: @user } } }
    end
  end

  # GET /members
  def index
    @company = current_tenant
    # Get members other the logged in user.
    @members = @company.users.active.includes(:role)

    respond_to do |format|
      format.html { render 'members/index' }
    end
  end

  # GET /members/:id
  def show
    @company = current_tenant
    @member = @company.users.where.not(id: current_user.id).active.find(params[:id])
    add_breadcrumb @member.name, :member_path

    respond_to do |format|
      format.html { render 'members/show' }
    end
  end

  # GET /members/:id/edit
  def edit
    @company = current_tenant
    @member = @company.users.active.find(params[:id])
    @roles = Role.all

    add_breadcrumb @member.name, :member_path
    add_breadcrumb 'Edit', :edit_member_path

    respond_to do |format|
      format.html { render 'members/edit' }
    end
  end

  # PUT /members/:id
  def update
    @company = current_tenant
    @member = @company.users.active.find(update_params[:id])
    @roles = Role.all
    status = 200 # Hope for the best :P

    # Update
    if @member.update(update_params)
      data = { role_name: @member.role.name, message: t('members.update.success') }
    else
      # status code
      status = 422
      data = { message: @member.errors.full_messages.join }
    end

    respond_to do |format|
      format.js { render json: { data: data }, status: status }
      format.html do
        if status == 200
          flash[:success] = t('members.update.success')
          redirect_to edit_member_path(@member)
        else
          flash[:error] = @member.errors.full_messages
          render 'members/edit'
        end
      end
    end
  end

  # DELETE /members/:id
  def destroy
    @member_to_be_deleted = current_tenant.users.active.find(params[:id])
    if @member_to_be_deleted.update(is_active: false)
      flash[:success] = t('members.destroy.success')
    else
      flash[:error] = @member_to_be_deleted.errors[:base]
    end

    respond_to do |format|
      format.html { redirect_to members_path }
    end
  end

  # GET /member/:id/change_password_form/
  # executes :changed_sys_generated_password? as before_action
  def show_change_password_form
    # TODO
    # Make sure that params[:id] == current_user.id through CANCANCAN
    @current_user = current_tenant.users.active.find(params[:id])

    respond_to do |format|
      format.html { render 'change_password_form' }
    end
  end

  # PUT /member/:id/change_password/
  # executes :changed_sys_generated_password? as before_action
  def change_password
    validation_error = false
    # TODO
    # Make sure that params[:id] == current_user.id through CANCANCAN
    @current_user = current_tenant.users.active.find(change_password_params[:id])
    @current_user.password = change_password_params[:password]
    @current_user.has_changed_sys_generated_password = true
    
    if @current_user.save
      # Re sign in the user after password change.
      sign_in(@current_user, bypass: true)
      flash[:success] = t('members.change_password.success')
    else
      flash[:error] = @current_user.errors.full_messages
      validation_error = true
    end

    respond_to do |format|
      format.html do
        if validation_error
          render 'members/change_password_form'
        else
          redirect_to dashboard_path
        end
      end
    end
  end

  private

  def changed_sys_generated_password?
    if current_user.has_changed_sys_generated_password?
      flash[:error] = t('members.show_change_password_form.failure')
      redirect_to members_path
    end
  end

  def set_invitation_view_variables
    # TODO
    # remove these lines as they will be handled through can can can
    # Get logged in User
    @user      = current_user

    # Get Roles
    @roles     = Role.all

    # Get Current Company
    @company = current_tenant
  end

  def create_params
    params.require(:user).permit(:first_name, :last_name, :email, :role_id, :designation, :skip_invitation_email)
  end

  def update_params
    params.require(:user).permit(:id, :first_name, :last_name, :role_id)
  end

  def change_password_params
    params.require(:user).permit(:id, :password)
  end

  def generate_random_password
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    (0...10).map { o[rand(o.length)] }.join
  end
end
