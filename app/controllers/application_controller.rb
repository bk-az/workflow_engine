class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied do |exception|
    flash[:warning] = exception.message
    redirect_to users_path
  end
end
