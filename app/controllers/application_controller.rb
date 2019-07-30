class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_filter :scope_current_tenant

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render file: "#{Rails.root}/public/404", status: :not_found
  end

  def current_tenant
    Company.find_by_subdomain! request.subdomain
  end
  helper_method :current_tenant

  private

  def scope_current_tenant
    Company.current_id = current_tenant.id
    yield
  ensure
    Company.current_id = nil
  end
end
