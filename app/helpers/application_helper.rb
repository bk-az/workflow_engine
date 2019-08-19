module ApplicationHelper
  def main_layout_class
    user_signed_in? ? 'col-lg-12' : 'offset-lg-1 col-lg-10 offset-md-1 col-md-10 col-sm-12'
  end

  def main_body_class_provider
    if !user_signed_in? && request.path != '/'
      'textured-background'
    end
  end
end
