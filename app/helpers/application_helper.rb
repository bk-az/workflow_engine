module ApplicationHelper
  def container_class
    user_signed_in? ? 'col-lg-12' : 'offset-lg-3 col-lg-6 offset-md-2 col-md-8 col-sm-12'
  end
end
