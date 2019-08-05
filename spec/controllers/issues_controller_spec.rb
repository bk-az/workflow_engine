require 'rails_helper'

RSpec.describe IssuesController, type: :controller do
<<<<<<< HEAD
=======
  before(:all) do
    @company = FactoryGirl.create(:company)
    @admin = FactoryGirl.create(:admin, company: @company)
    @member = FactoryGirl.create(:member, company: @company)
  end
  before(:each) do
    @request.host = "#{@company.subdomain}.lvh.me:3000"
    Company.current_id = @company.id
    sign_in @member
  end

>>>>>>> 3e6d3ddb7129b1d47955ee772c7d72301f13dcfd
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

  context 'Get #new' do
    it 'it render new template' do
      get :new
      expect(response).to be_success
    end
  end

  context 'Get #show' do
    before :all do
      @issue = FactoryGirl.create(:issue, company: @company)
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
<<<<<<< HEAD
    context 'with valid attributes' do
      it 'saves the new issue in the database' do
        expect { post :create, issue: FactoryGirl.attributes_for(:issue) }
          .to change(Issue, :count).by(1)
=======
    before(:each) do
      @request.host = "#{@company.subdomain}.lvh.me:3000"
      Company.current_id = @company.id
      sign_in @member
    end
    let(:issue_attr) {@issue_attr = FactoryGirl.attributes_for(:issue, company_id: @company.id)}

    context 'with valid attributes' do
      it 'saves the new issue in the database' do
        expect do
          post :create, issue: issue_attr
          Company.current_id = @company.id
        end.to change(Issue, :count).by(1)
>>>>>>> 3e6d3ddb7129b1d47955ee772c7d72301f13dcfd
      end

      it "redirects to that new issue's page" do
        post :create, issue: issue_attr
        Company.current_id = @company.id
        expect(response).to redirect_to Issue.last
      end
    end
<<<<<<< HEAD
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
          :issue,
          title: 'This is edited issue',
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
=======

    context 'with invalid attributes' do
      it 'does not save the new issue in the database' do
        expect { post :create, issue: FactoryGirl.attributes_for(:invalid_issue) }
        .to_not change(Project, :count)
      end
      it 're-renders the :new template' do
        post :create, issue: FactoryGirl.attributes_for(:invalid_issue)
        expect(response).to render_template :new
>>>>>>> 3e6d3ddb7129b1d47955ee772c7d72301f13dcfd
      end
    end
  end
<<<<<<< HEAD
=======

  describe 'PUT update' do
    context 'Login as Member' do
      before(:each) do
        @issue = FactoryGirl.build(:issue)
        @issue.assignee_id = @member.id
        @issue.save
        @issue = FactoryGirl.build(:issue)
        @issue.creator_id = @member.id
        @issue.save
        @request.host = "#{@company.subdomain}.lvh.me:3000"
        Company.current_id = @company.id
        sign_in @member
      end

      context 'valid attributes' do
        it 'locates the requested @issue with same assignee_id' do
          put :update, id: @issue, issue: FactoryGirl.attributes_for(:issue)
          Company.current_id = @company.id
          expect(assigns(:issue)).to eq(@issue)
        end

        it "changes @issue's attributes with same assignee_id" do
          put :update, id: @issue, issue: FactoryGirl.attributes_for(
            :issue, title: 'This is edited issue',
            description: 'Some changed description'
            )
          Company.current_id = @company.id
          @issue.reload
          expect(@issue.title).to eq('This is edited issue')
          expect(@issue.description).to eq('Some changed description')
        end

        it 'redirects to the updated issue with same assignee_id' do
          put :update, id: @issue, issue: FactoryGirl.attributes_for(:issue)
          Company.current_id = @company.id
          expect(response).to redirect_to @issue
        end

        it 'locates the requested @issue with same creator_id' do
          put :update, id: @issue, issue: FactoryGirl.attributes_for(:issue)
          Company.current_id = @company.id
          expect(assigns(:issue)).to eq(@issue)
        end

        it "changes @issue's attributes same creator_id" do
          put :update, id: @issue, issue: FactoryGirl.attributes_for(
            :issue, title: 'This is edited issue',
            description: 'Some changed description'
            )
          Company.current_id = @company.id
          @issue.reload
          expect(@issue.title).to eq('This is edited issue')
          expect(@issue.description).to eq('Some changed description')
        end

        it 'redirects to the updated issue same creator_id' do
          put :update, id: @issue, issue: FactoryGirl.attributes_for(:issue)
          Company.current_id = @company.id
          expect(response).to redirect_to @issue
        end
      end

      context 'invalid attributes' do
        it 'locates the requested @issue' do
          put :update,
          id: @issue, issue: FactoryGirl.attributes_for(:invalid_issue)
          Company.current_id = @company.id
          expect(assigns(:issue)).to eq(@issue)
        end

        it "does not change @issue's attributes" do
          put :update,
          id: @issue, issue: FactoryGirl.attributes_for(:issue, title: nil)
          Company.current_id = @company.id
          @issue.reload
          expect(@issue.title).to eq('This is newly created issue')
        end

        it 're-renders the edit method' do
          put :update, id: @issue, issue: FactoryGirl.attributes_for(
            :invalid_issue
            )
          Company.current_id = @company.id
          expect(response).to render_template :edit
        end
      end
    end

    context 'Login as Admin' do
      before(:each) do
        @request.host = "#{@company.subdomain}.lvh.me:3000"
        Company.current_id = @company.id
        sign_in @admin
      end
      before :all do
        @issue = FactoryGirl.create(:issue, company: @company)
      end
      context 'valid attributes' do
        it 'locates the requested @issue' do
          put :update, id: @issue, issue: FactoryGirl.attributes_for(:issue)
          expect(assigns(:issue)).to eq(@issue)
        end

        it "changes @issue's attributes" do
          put :update, id: @issue, issue: FactoryGirl.attributes_for(
            :issue, title: 'This is edited issue',
                    description: 'Some changed description'
          )
          @issue.reload
          expect(@issue.title).to eq('This is edited issue')
          expect(@issue.description).to eq('Some changed description')
        end

        it 'redirects to the updated issue' do
          put :update, id: @issue, issue: FactoryGirl.attributes_for(:issue)
          expect(response).to redirect_to @issue
        end
      end

      context 'invalid attributes' do
        it 'locates the requested @issue' do
          put :update,
              id: @issue, issue: FactoryGirl.attributes_for(:invalid_issue)
          expect(assigns(:issue)).to eq(@issue)
        end

        it "does not change @issue's attributes" do
          put :update,
              id: @issue, issue: FactoryGirl.attributes_for(:issue, title: nil)
          @issue.reload
          expect(@issue.title).to eq('This is newly created issue')
        end

        it 're-renders the edit method' do
          put :update, id: @issue, issue: FactoryGirl.attributes_for(
            :invalid_issue
          )
          expect(response).to render_template :edit
        end
      end
    end
  end

  context 'DELETE #destroy' do
    before(:each) do
      @issue = FactoryGirl.build(:issue, company: @company)
      @issue.creator_id = @member.id
      @issue.save
      @request.host = "#{@company.subdomain}.lvh.me:3000"
      Company.current_id = @company.id
      sign_in @member
    end

    it 'should delete issue' do
      delete :destroy, id: @issue.id
      expect(response).to redirect_to issues_url
    end
  end
>>>>>>> 3e6d3ddb7129b1d47955ee772c7d72301f13dcfd

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
<<<<<<< HEAD
=======

>>>>>>> 3e6d3ddb7129b1d47955ee772c7d72301f13dcfd
    it 'routes to #update via PATCH' do
      expect(patch: '/issues/1').to route_to('issues#update', id: '1')
    end
  end
<<<<<<< HEAD
end
=======
end
>>>>>>> 3e6d3ddb7129b1d47955ee772c7d72301f13dcfd
