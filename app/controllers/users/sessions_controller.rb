class Users::SessionsController < Devise::SessionsController
  def new
    @email = params[:user_email]
    super
  end

  def after_sign_in_path_for(resource)
    flash[:success] = t('.success')
    if current_user.has_changed_sys_generated_password
      members_url(subdomain: current_user.company.subdomain)
    else
      change_password_form_member_url(current_user, subdomain: current_user.company.subdomain)
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
