require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do
  before :each do
    @issue = FactoryGirl.create(:issue)
    @document = FactoryGirl.create(:document)
  end

  context 'GET #index' do
    it 'returns a success response' do
      get :index, issue_id: @issue
      expect(response).to render_template('index')
      expect(response).to be_success
      expect(response.status).to eq(200)
    end
  end
end
