class Users::RegistrationsController < Devise::RegistrationsController
  # GET /resource/sign_up
  def new
    @id_of_administrator_role = Role.where(name: 'Administrator').first.id
    super
  end

  # GET /resource/edit
  def edit
    @id_of_administrator_role = Role.where(name: 'Administrator').first.id
    super
  end

  private

  # Override Sign Up Parameters
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :company_id, :role_id, :designation, :email, :password, :password_confirmation)
  end

  # Override Update Parameters
  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :role_id, :designation, :email, :password, :password_confirmation, :current_password)
  end
end
