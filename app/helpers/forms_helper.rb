# forms_helper.rb
module FormsHelper
  def get_roles(roles)
    roles_collection ||= roles.collect { |role| [role.name, role.id] }
    roles_collection
  end
end
