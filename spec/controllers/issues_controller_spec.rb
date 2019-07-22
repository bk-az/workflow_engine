require 'rails_helper'

RSpec.describe IssuesController, type: :controller do



 context "Get #index" do
  it 'returns a success response' do
    get :index
    expect(response).to be_success
  end
 end

 context "Get #new" do
  it 'it render new template' do
    get :new
    expect(response).to be_success
  end
 end

 context "Get #show" do

    before :all do
      @issue = FactoryGirl.create(:issue)
    end

    it 'returns a success response' do
      get :show, id: @issue
      expect(assigns(:issue)).to eq(@issue)
    end
    it 'should success and render to the :show template' do
      get :show, id: FactoryGirl.create(:issue)
      expect(response).to have_http_status(200)
      expect(response).to render_template :show
    end
 end

  context 'POST #create' do
    
    context 'with valid attributes' do
      it 'saves the new issue in the database' do
        expect { post :create, issue: FactoryGirl.attributes_for(:issue) }
          .to change(Issue, :count).by(1)
       
      end
      it "redirects to that new issue's page" do
        post :create, issue: FactoryGirl.attributes_for(:issue)
        expect(response).to redirect_to Issue.last
      end
    end

    # context 'with invalid attributes' do
    #   it 'does not save the new issue in the database' do
    #     expect { post :create, issue: FactoryGirl.attributes_for(:invalid_issue) }
    #       .to_not change(Project, :count)
    #   end
    #   it 're-renders the :new template' do
    #     post :create, issue: FactoryGirl.attributes_for(:invalid_issue)
    #     expect(response).to render_template :new
    #   end
    # end
  end

describe 'PUT update' do
    before :all do
      @issue = FactoryGirl.create(:issue)
    end

    context 'valid attributes' do
      it 'locates the requested @issue' do
        put :update, id: @issue, issue: FactoryGirl.attributes_for(:issue)
        expect(assigns(:issue)).to eq(@issue)
      end

      it "changes @issue's attributes" do
        put :update, id: @issue, issue: FactoryGirl.attributes_for(
          :issue,  title: 'This is edited issue',
          description: 'Some changed description',
          start_date: '2017-07-23',
          due_date: '2017-07-23',
          progress: '0',
          priority: '2',
          company_id: '1',
          creator_id: '1',
          assignee_id: '1',
          project_id: '1',
          issue_type_id: '1',
          issue_state_id: '1'
        )
        @issue.reload
        expect(@issue.title).to eq('This is edited issue')
        expect(@issue.description).to eq('Some changed description')
      end

      # it 'redirects to the updated issue' do
      #   put :update, id: @issue, issue: FactoryGirl.attributes_for(:issue)
      #   response.should redirect_to @issue
      # end
    end

    # context 'invalid attributes' do
    #   it 'locates the requested @issue' do
    #     put :update, id: @issue,
    #                 issue: FactoryGirl.attributes_for(:invalid_issue)
    #     expect(assigns(:issue)).to eq(@issue)
    #   end

    #   it "does not change @issue's attributes" do
    #     put :update, id: @issue,
    #                  issue: FactoryGirl.attributes_for(
    #                    :issue, title: 'This is edited issue', description: nil
    #                  )
    #     @issue.reload
    #     expect(@issue.title).to_not eq('Edit Test Proj')
    #     expect(@issue.description).to eq('I am editing this test project.')
    #   end

    #   it 're-renders the edit method' do
    #     put :update, id: @project, project: FactoryGirl.attributes_for(
    #       :invalid_project
    #     )
    #     response.should render_template :edit
    #   end
    # end
  end
end

 # context 'PUT #update' do
 # let!(:issue) { create :issue }
 
 # it 'should update Issue info' do
 #   params = {
 #    title: 'This is newly created issue', 
 #    description: 'Some description', 
 #    start_date: '2017-07-23',
 #    due_date: '2017-07-23',
 #    progress: '0',
 #    priority: '2',
 #    company_id: '1',
 #    creator_id: '1',
 #    assignee_id: '1',
 #    project_id: '1',
 #    issue_type_id: '1',
 #    issue_state_id: '1'
 #   }

 #   put :update, params: { id: issue.id, product: params }
 #   issue.reload
 #   params.keys.each do |key|
 #    expect(issue.attributes[key.to_s]).to eq params[key]
 #   end
 #  end
 # end

 # context 'DELETE #destroy' do
 #    let!(:issue) { create :issue }

 #      it 'should delete issue' do
 #         expect { delete :destroy, params: { id: issue.id } }.to change(Issue, :count).by(-1)
 #         expect(flash[:notice]).to eq 'Issue was successfully deleted.'
 #        end
 # end






  context 'Routes testing' do

    it 'routes to #index' do
     expect(get: '/issues').to route_to('issues#index')
    end

    it 'routes to #show' do
     expect(get: '/issues/1').to route_to('issues#show', id: '1')
    end

    it 'routes to #new' do
     expect(get: '/issues/new').to route_to('issues#new')
    end
   
    it 'routes to #update via PUT' do
     expect(put: '/issues/1').to route_to('issues#update', id: '1')
    end
    
    it 'routes to #update via PATCH' do
     expect(patch: '/issues/1').to route_to('issues#update', id: '1')
    end
 end

