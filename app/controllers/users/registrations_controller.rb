class Users::RegistrationsController < Devise::RegistrationsController
  # GET /resource/sign_up
  def new
    @new_user = User.new
    @new_user.build_company
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
      render 'devise/registrations/new'
    rescue ActiveRecord::ActiveRecordError => e
      @new_user.errors[:base] << e.message
      render 'devise/registrations/new'
    else
      flash[:success] = t('.success')
      redirect_to new_user_session_url(subdomain: @new_user.company.subdomain, user_email: @new_user.email)
    end
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
