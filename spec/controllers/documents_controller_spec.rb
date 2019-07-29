require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do
  before :each do
    @issue = FactoryGirl.create(:issue)
    @document = FactoryGirl.create(:document)
  end

  context 'GET #index' do
    it 'returns a success response' do
      get :index, :issue_id => @issue
       expect(response).to render_template('index')
       expect(response).to be_success
       expect(response.status).to eq(200)
    end
  end

  # context 'POST #create' do

  #   context 'with valid attributes' do
  #     it 'saves the new issue in the database' do
  #       expect { post :create , { :issue_id => @issue  }, document: @document }
  #         .to change(Document, :count).by(1)
       
  #     end
  #     # it "redirects to that new issue's page" do
  #     #   post :create, issue: FactoryGirl.attributes_for(:issue)
  #     #   expect(response).to redirect_to Issue.last
  #     # end
  #   end
  # end



end
