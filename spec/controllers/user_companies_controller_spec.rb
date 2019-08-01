require 'rails_helper'

RSpec.describe UserCompaniesController, type: :controller do
  describe 'GET #find' do
    it 'should success and render to :find view' do
      get :find
      expect(response).to have_http_status(200)
      expect(response).to render_template(:find)
    end
  end

  describe 'POST #find_user_by_email' do
    context 'with valid attributes' do
      it 'should render the js response.' do
        xhr :post, :find_user_by_email, email: 'abc@7vals.com'
        expect(response).to have_http_status(200)
        expect(response).to render_template(:find_user_by_email_response)
      end
    end
  end

  describe 'GET #show_companies' do
    it 'should success and render to :show_companies view' do
      get :show_companies, user_email: 'abc@7vals.com'
      expect(response).to have_http_status(200)
      expect(response).to render_template(:show_companies)
    end
  end
end
