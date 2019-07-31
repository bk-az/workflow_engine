class UserCompaniesController < ApplicationController
  # GET user_companies/find
  def find
    respond_to do |format|
      format.html { render 'user_companies/find' }
    end
  end

  # POST user_companies/find
  def find_user_by_email
    @found_users = User.unscoped.where(email: params[:email])

    respond_to do |format|
      format.js { render 'user_companies/find_user_by_email_response' }
    end
  end

  # GET user_companies/show_companies
  def show_companies
    @email = params[:user_email]
    @companies = Company.where(id: User.unscoped.where(email: @email).pluck(:company_id))
    respond_to do |format|
      format.html { render 'user_companies/show_companies' }
    end
  end
end
