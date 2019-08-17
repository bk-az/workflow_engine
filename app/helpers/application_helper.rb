module ApplicationHelper
  def main_layout_class
    user_signed_in? ? 'col-lg-12' : 'offset-lg-3 col-lg-6 offset-md-2 col-md-8 col-sm-12'
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