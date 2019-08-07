require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do
  before(:all) do
    @company = FactoryGirl.create(:company)
    @project = FactoryGirl.create(:project, company: @company)
    @issue = FactoryGirl.create(:issue, company: @company)
    @document = FactoryGirl.create(:document, company: @company)
    @admin = FactoryGirl.create(:admin, company: @company)
  end

  before :each do
    @request.host = "#{@company.subdomain}.lvh.me:3000"
    Company.current_id = @company.id
    sign_in @admin
  end

  context 'GET #index' do
    it 'returns a success response' do
      get :index, issue_id: @issue.id, project_id: @project.id
      Company.current_id = @company.id
      expect(response).to render_template('index')
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end
end
