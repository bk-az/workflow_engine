class Users::SessionsController < Devise::SessionsController
  def new
    @email = params[:user_email]
    flash.now[:success] = t('users.sessions.new.success') if params[:newly_signed_up]
    super
  end

  private

  def after_sign_in_path_for(resource)
    if current_user.has_changed_sys_generated_password
      dashboard_path
    else
      change_password_form_member_path(current_user)
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
