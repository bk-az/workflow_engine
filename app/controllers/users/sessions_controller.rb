class Users::SessionsController < Devise::SessionsController
  def after_sign_in_path_for(resource)
    flash[:success_notification] = 'Signed In Successfully!'
    if current_user.is_invited_user
      member_setpassword_path
    else
      members_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
