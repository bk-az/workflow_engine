class Users::RegistrationsController < Devise::RegistrationsController
  # GET /resource/sign_up
  def new
    @new_user = User.new
    super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # POST /resource/create
  def create
    ActiveRecord::Base.transaction do
      begin
        # Create new user and new company
        @new_user = User.new(sign_up_params)
        @new_user.role_id = Role.where(name: 'Administrator').first.id
        @new_user.save!
        Company.find(@new_user.company_id).update!(owner_id: @new_user.id)
        # if @new_user.save
        #   Company.find(@new_user.company_id).update!(owner_id: @new_user.id)
        # else
        #   render 'devise/registrations/new'
        # end
      rescue ActiveRecord::ActiveRecordError => e
        binding.pry
        render 'devise/registrations/new'
      else
        redirect_to new_user_session_path, flash: { success_notificaton: 'Your account has been created successfully. A confirmation email is sent to you. Confirm your email and login here.' }
      end
    end
  end

  private

  # Override Sign Up Parameters
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :company_id, :designation, :email, :password, :password_confirmation, company_attributes: [:name, :subdomain, :description])
  end

  # Override Update Parameters
  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :role_id, :designation, :email, :password, :password_confirmation, :current_password)
  end
end
