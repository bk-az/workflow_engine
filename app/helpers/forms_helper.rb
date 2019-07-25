# forms_helper.rb
module FormsHelper
  def setup_user(user)
    user.company ||= Company.new
    user
  end
end
