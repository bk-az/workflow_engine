class Users::SessionsController < Devise::SessionsController
  def after_sign_in_path_for(resource)
    flash[:success] = t('.success')
    if current_user.has_changed_sys_generated_password
      members_set_password_path(current_user)
    else
      members_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
