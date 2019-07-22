class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_filter :scope_current_tenant

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render plain: 'Company Not Found'
  end

  private

  def current_tenant
    Company.find_by_subdomain! request.subdomain
  end
  helper_method :current_tenant

  def scope_current_tenant
    Company.current_id = current_tenant.id
    yield
  ensure
    Company.current_id = nil
  end
end
