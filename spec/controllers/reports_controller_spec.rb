require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  before(:all) do
    @company = create(:company)
    @admin = create(:admin, company: @company)
    @member = create(:member, company: @company)
  end

  let(:issue) { create(:issue, company: @company) }

  before(:each) do
    @request.host = "#{@company.subdomain}.lvh.me:3000"
  end

  describe 'Controller Actions' do
    before(:each) do
      sign_in @admin
    end
    it 'should be render to issues action' do
      get :issues
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template(:issues)
    end
  end

  describe 'Authorization' do
    context 'As an Admin of Company' do
      before(:each) do
        sign_in @admin
      end
      it 'should be able to access issues report' do
        get :issues
        expect(response).to be_success
      end
    end
    context 'As a Member of Company' do
      before(:each) do
        sign_in @member
      end
      it 'should not be able to access issues report' do
        expect do
          get :issues
        end.to raise_exception(CanCan::AccessDenied)
      end
    end
  end
end
