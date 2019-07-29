class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def current_ability
    @current_ability ||= Ability.new(current_user, project_id: params[:project_id].to_i)
  end
end
