require 'rails_helper'

RSpec.describe IssuesController, type: :controller do
  context 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_success
    end
  end

  context 'GET #filter' do
    it 'returns a success response' do
      xhr :get, :filter, format: :js
      expect(response).to be_success
    end
  end
end
