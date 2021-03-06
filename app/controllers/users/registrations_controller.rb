class Users::RegistrationsController < Devise::RegistrationsController
  # GET /resource/sign_up
  def new
    @new_user = User.new
    @new_user.build_company
    super
  end

  # GET /resource/edit
  def edit
    add_breadcrumb 'My Workplace', :dashboard_path
    add_breadcrumb 'Edit', :edit_user_registration_path
    super
  end

  # POST /resource/create
  def create
    begin
      ActiveRecord::Base.transaction do
        @new_user = User.new(sign_up_params)
        @new_user.role_id = Role.admin.id

        @new_user.save!
        @new_user.company.update!(owner_id: @new_user.id)
      end
    rescue ActiveRecord::RecordInvalid
      flash.now[:error] = @new_user.errors.full_messages
      render 'devise/registrations/new'
    rescue ActiveRecord::ActiveRecordError => e
      flash.now[:error] = @new_user.errors.full_messages
      flash.now[:error] << e.message
      render 'devise/registrations/new'
    else
      redirect_to new_user_session_url(subdomain: @new_user.company.subdomain, user_email: @new_user.email, newly_signed_up: true)
    end
  end

  # GET /users/sign_up/verify_subdomain_availability?subdomain=xyz
  def verify_subdomain_availability
    respond_to do |format|
      format.js do
        render json: { data: { is_found: Company.where(subdomain: params[:subdomain]).exists? } }
      end
    end
  end

  protected

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  private

  # Override Sign Up Parameters
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :company_id, :designation, :email, :password, :password_confirmation, company_attributes: [:name, :subdomain, :description])
  end

  # Override Update Parameters
  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :role_id, :designation, :email, :password, :password_confirmation, :current_password)
  end
end
