module ApplicationHelper
  WITHOUT_TEXTURED_BACKGROUND_PAGES_PATHS = [
    '/' # Homepage
  ].freeze

  def main_layout_class
    user_signed_in? ? 'col-lg-12' : 'offset-lg-1 col-lg-10 offset-md-1 col-md-10 col-sm-12'
  end

  def main_body_class_provider
    'textured-background' if !user_signed_in? && !WITHOUT_TEXTURED_BACKGROUND_PAGES_PATHS.include?(request.path)
  end

  def sidebar_toggle_class
    'toggled' if session.has_key?(:is_sidebar_collapsed) 
  end

  def sidebar_active_class_provider(request_path, current_link_name)
    if request_path.split('/')[1] == current_link_name
      'active'
    end
  end
end