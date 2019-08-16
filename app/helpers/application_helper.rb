module ApplicationHelper
  def main_layout_class
    user_signed_in? ? 'col-lg-12' : 'offset-lg-3 col-lg-6 offset-md-2 col-md-8 col-sm-12'
  end

  def sidebar_toggle_class
    'toggled' if session.has_key?(:is_sidebar_collapsed) 
  end
end