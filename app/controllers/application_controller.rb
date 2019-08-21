# Application Controller
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # protect_from_forgery with: :exception
  protect_from_forgery with: :exception
  around_filter :scope_current_tenant

  # Override this method to handle request from devise controllers.
  def authenticate_user!(opts = {})
    Company.current_id = Company.find_by_subdomain request.subdomain if Company.current_id.nil?
    super
  end

  # MULTI TENANCY CODE
  WIHTOUT_SUBDOMAIN_URLS = [
    '/',
    '/users/sign_up',
    '/user_companies/show_companies',
    '/user_companies/find'
  ]

  SUBDOMAIN_INDEPENDENT_URLS = [
    ['POST', '/users'],
    ['PUT', '/users'],
    ['GET', '/users/sign_up/verify_subdomain_availability']
  ]

  rescue_from ActiveRecord::RecordNotFound, CanCan::AccessDenied do |exception|
    render file: "#{Rails.root}/public/404", status: :not_found
  end

  def current_tenant
    Company.find_by_subdomain! request.subdomain
  end
  helper_method :current_tenant

  def sidebar_toggle
    if params[:is_collapsed].to_i.zero?
      session.delete(:is_sidebar_collapsed) if session.has_key?(:is_sidebar_collapsed)
    elsif params[:is_collapsed].to_i == 1
      session[:is_sidebar_collapsed] = true
    end
    respond_to do |format|
      format.js { render json: {}, status: 200 }
    end
  end

  private

  def scope_current_tenant
    # RENDER 404 RESPONSE IF THE PATH OF THE REQUESTED URL BELONGS TO THE URLS THAT ARE ACCESSIBLE
    # ONLY WITH SUBDOMAINS AND VICE VERSA
    # SOME URLS LIKE '/users' ARE ACCESSIBLE WITH BOTH SUBDOMAIN AND WITHOUT SUBDOMAIN.
    if SUBDOMAIN_INDEPENDENT_URLS.include?([request.method, request.path])
      Company.current_id = current_tenant.id if request.subdomain.present?
    elsif WIHTOUT_SUBDOMAIN_URLS.include?(request.path) && request.subdomain.present?
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
    elsif request.path =~ /\bprojects\/\d+\/project_memberships\b/
      @current_ability ||= Ability.new(current_user, project_id: params[:project_id].to_i)
    else
      super
    end
  end
end
