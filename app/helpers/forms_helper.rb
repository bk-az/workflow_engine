# forms_helper.rb
module FormsHelper
  def setup_user(user)
    user.company ||= Company.new
    user
  end

  def setup_roles_select_options(roles)
    roles.collect { |role| [role.name, role.id] }
  end
end
