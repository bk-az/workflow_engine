class Users::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @id_of_administrator_role = Role.where(name: 'Administrator').first.id
    super
  end

  # POST /resource
  def create
    new_user_params = sign_up_params
    if new_user_params[:password].nil? && new_user_params[:password_confirmation].nil?
      # Generate Custom Password and treat user an invited member.
      new_user = User.new
      new_user.first_name = new_user_params[:first_name]
      new_user.last_name = new_user_params[:last_name]
      new_user.email = new_user_params[:email]
      new_user.role_id = new_user_params[:role_id]
      new_user.password = 'default_password'
      new_user.save

      new_user.send_invitation_email

      redirect_to new_user_session_path, flash: { success_notification: "We have invited '#{new_user.first_name}' successfully through an email." }
    else
      super
    end
  end

  # GET /resource/edit
  def edit
    @id_of_administrator_role = Role.where(name: 'Administrator').first.id
    super
  end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

  # Override Sign Up Parameters
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :role_id, :designation, :email, :password, :password_confirmation)
  end

  # Override Update Parameters
  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :role_id, :designation, :email, :password, :password_confirmation, :current_password)
  end
end
