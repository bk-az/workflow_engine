require 'rails_helper'

RSpec.describe MembersController, type: :controller do
  before(:all) do
    @company = create(:company)
    @role = create(:role_admin)
  end
  before :each do
    Company.current_id = @company.id
    @member = build(:user)
    @member.company_id = @company.id
    @member.role_id = @role.id
    @member.save
    @request.host = "#{@company.subdomain}.lvh.me:3000"
    sign_in(@member)
  end

  let(:user) { create(:user) }
  let(:user_params) { { first_name: 'asdfasdf', last_name: 'asdfasdf', role_id: @role.id, email: Faker::Internet.email, skip_invitation_email: true } }
  let(:update_params) { { id: @member.id, first_name: 'blabla', last_name: 'blabla', role_id: @role.id } }
  let(:change_password_params) { { id: @member.id, password: 'blabla' } }

  describe 'GET #index' do
    it 'should success and render to :index view' do
      get :index
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end
  end
  
  describe 'GET #show' do
    it 'should assign the requested member to @member' do
      get :show, id: @member
      expect(assigns(:member)).to eq(@member)
    end
  end

  describe 'GET #show' do
    it 'should render the show page' do
      get :show, id: @member
      expect(response).to have_http_status(200)
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #privileges' do
    it 'should render the privileges page' do
      get :privileges
      expect(response).to have_http_status(200)
      expect(response).to render_template(:privileges)
    end
  end

  describe 'GET #privileges_show' do
    it 'should set user variable as found user.' do
      xhr :get, :privileges_show, id: @member
      expect(assigns(:user)).to eq(@member)
    end
  end

  describe 'GET #edit' do
    it 'should find user correspoding to the given id.' do
      get :edit, id: @member
      expect(assigns(:member)).to eq(@member)
    end
  end

  describe 'GET #edit' do
    it 'should render the edit page.' do
      get :edit, id: @member
      expect(response).to have_http_status(200)
      expect(response).to render_template(:edit)
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it 'should find the user with given id' do
        xhr :put, :update, id: @member, user: update_params
        expect(assigns(:member)).to eq(@member)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it 'should find the user with given id' do
        put :update, id: @member, user: update_params
        expect(assigns(:member)).to eq(@member)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with valid attributes' do
      it 'should find the user with given id' do
        delete :destroy, id: @member
        expect(assigns(:member_to_be_deleted)).to eq(@member)
      end
    end
  end

  describe 'GET #show_change_password_form' do
    it 'should render the show password form page' do
      get :show_change_password_form, id: @member
      expect(response).to have_http_status(200)
      expect(response).to render_template(:change_password_form)
    end
  end

  describe 'PUT #change_password' do
    context 'with valid attributes' do
      it 'should find the user with given id' do
        put :change_password, id: @member, user: change_password_params
        expect(assigns(:current_user)).to eq(@member)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'should save the new member in the database' do
        expect { post :create, user: user_params }.to change(User.unscoped, :count).by(1)
      end
    end
  end
end
