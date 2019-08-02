class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  around_filter :scope_current_tenant

  def authenticate_user!(opts = {})
    Company.current_id = Company.find_by_subdomain request.subdomain if Company.current_id.nil?
    super
  end

  WIHTOUT_SUBDOMAIN_URLS = [
    '/users/sign_up',
    '/user_companies/show_companies',
    '/user_companies/find'
  ]

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render file: "#{Rails.root}/public/404", status: :not_found
  end

  def current_tenant
    Company.find_by_subdomain! request.subdomain
  end
  helper_method :current_tenant

  private

  def scope_current_tenant
    if WIHTOUT_SUBDOMAIN_URLS.include?(request.path) && request.subdomain.present?
      render file: "#{Rails.root}/public/404", status: :not_found
      return
    else
      Company.current_id = current_tenant.id unless WIHTOUT_SUBDOMAIN_URLS.include? request.path
    end
    yield
  ensure
    Company.current_id = nil
  end

  # Override current_ability for CANCANCAN.
  def current_ability
    if request.path =~ /members\/\d+\/(change_password_form|change_password)/
      @current_ability ||= Ability.new(current_user, change_password_member_id: params[:id].to_i)
    else
      super
    end
  end
end
