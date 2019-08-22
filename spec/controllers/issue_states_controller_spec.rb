require 'rails_helper'

RSpec.describe IssueStatesController, type: :controller do
  before(:all) do
    @company = create(:company)
    @admin = create(:admin, company: @company)
    @member = create(:member, company: @company)
  end

  let(:issue_state)        { create(:issue_state, company: @company) }

  let(:issue_state_params) { attributes_for(:issue_state) }

  before(:each) do
    @request.host = "#{@company.subdomain}.lvh.me:3000"
  end


  describe 'Controller Action Testing' do
    before(:each) do
      sign_in @admin
    end
    context 'GET #index' do
      it 'should success and render to :index view' do
        get :index
        expect(response).to have_http_status(200)
        expect(response).to render_template(:index)
      end
      it 'should assign issue_states to all issue_states of current company' do
        get :index
        Company.current_id = @company.id
        expect(assigns(:issue_states)).to eq IssueState.all
      end
    end
    context 'GET #new' do
      it 'should success and render to :new view' do
        xhr :get, :new
        expect(response).to have_http_status(200)
        expect(response).to render_template(:new)
      end
    end
    context 'GET #edit' do
      it 'should success and render to :edit view' do
        xhr :get, :edit, id: issue_state
        expect(response).to have_http_status(200)
        expect(response).to render_template(:edit)
      end
      it 'should assign issue_state to current issue_state' do
        xhr :get, :edit, id: issue_state
        expect(assigns(:issue_state)).to eq issue_state
      end
    end
    context 'POST #create' do
      before(:each) do
        Company.current_id = @company.id
      end
      it 'should create new issue_state in database' do
        expect do
          xhr :post, :create, issue_state: issue_state_params
          Company.current_id = @company.id
        end.to change(IssueState, :count).by(1)
      end
    end
    context 'PATCH #update' do
      before(:each) do
        @issue_state = create(:issue_state)
        Company.current_id = @company.id
      end
      it 'should update issue_state in database' do
        xhr :patch, :update, id: @issue_state, issue_state: issue_state_params
        expect(assigns(:issue_state).name).to eq issue_state_params[:name]
      end
    end
    context 'DELETE #destroy' do
      before(:each) do
        @issue_state = create(:issue_state)
        Company.current_id = @company.id
      end
      it 'should destroy issue_state in database' do
        expect do
          xhr :delete, :destroy, id: @issue_state.id
          Company.current_id = @company.id
        end.to change(IssueState, :count).by(-1)
      end
      it 'should not destroy issue_state if at least one issue is using it' do
        create(:issue, issue_state: @issue_state)
        expect do
          xhr :delete, :destroy, id: @issue_state.id
          Company.current_id = @company.id
        end.to_not change(IssueState, :count)
      end
    end
  end

  describe 'Authorization' do
    context 'When is an admin' do
      before(:each) do
        sign_in @admin
      end
      it 'should be able to index issue_states' do
        expect do
          get :index
        end.to_not raise_error
      end
      it 'should be able to new issue_state' do
        expect do
          xhr :get, :new
        end.to_not raise_error
      end
      it 'should be able to create issue_state' do
        expect do
          xhr :post, :create, issue_state: issue_state_params
        end.to_not raise_error
      end
      it 'should be able to update issue_state' do
        expect do
          xhr :put, :update, id: issue_state, issue_state: issue_state_params
        end.to_not raise_error
      end
      it 'should be able to destroy issue_state' do
        expect do
          xhr :delete, :destroy, id: issue_state
        end.to_not raise_error
      end
    end

    context 'When is a member' do
      before(:each) do
        sign_in @member
      end
      it 'should not be able to index issue_states' do
        expect(get(:index)).to have_http_status(404)
      end
      it 'should not be able to new issue_state' do
        expect(xhr(:get, :new)).to have_http_status(404)
      end
      it 'should not be able to create issue_state' do
        expect(xhr(:post, :create, issue_state: issue_state_params)).to have_http_status(404)
      end
      it 'should not be able to update issue_state' do
        expect(xhr(:put, :update, id: issue_state, issue_state: issue_state_params)).to have_http_status(404)
      end
      it 'should not be able to destroy issue_state' do
        expect(xhr(:delete, :destroy, id: issue_state)).to have_http_status(404)
      end
    end
  end
end
