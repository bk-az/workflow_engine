require 'rails_helper'

RSpec.describe IssueTypesController, type: :controller do
  before(:all) do
    @company = create(:company)
    @admin = create(:admin, company: @company)
    @member = create(:member, company: @company)
    @project = create(:project, company: @company)
  end

  let(:project)             { create(:project, company: @company) }
  let(:issue_type)          { create(:issue_type, company: @company) }
  let(:project_issue_type)  { create(:issue_type, project: project, company: @company) }

  let(:issue_type_params) { attributes_for(:issue_type, project_id: @project.id) }
  let(:global_issue_type_params) { attributes_for(:issue_type) }

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
      it 'should assign issue_types to all issue_types of current company' do
        get :index
        Company.current_id = @company.id
        expect(assigns(:issue_types)).to eq IssueType.all
      end
      it 'should assign issue_types to all issue_types of current project or global' do
        get :index, project_id: project.id
        Company.current_id = @company.id
        project_issue_type
        expect(assigns(:issue_types)).to eq IssueType.where(project_id: [project.id, nil])
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
        xhr :get, :edit, id: issue_type
        expect(response).to have_http_status(200)
        expect(response).to render_template(:edit)
      end
      it 'should assign issue_type to current issue_type' do
        xhr :get, :edit, id: issue_type
        expect(assigns(:issue_type)).to eq issue_type
      end
    end
    context 'POST #create' do
      before(:each) do
        Company.current_id = @company.id
      end
      it 'should create new issue_type in database' do
        expect do
          xhr :post, :create, issue_type: issue_type_params
          Company.current_id = @company.id
        end.to change(IssueType, :count).by(1)
      end
      it 'should create new issue_type associated with current project in database' do
        expect do
          xhr :post, :create, project_id: @project.id, issue_type: issue_type_params
          Company.current_id = @company.id
        end.to change(@project.issue_types, :count).by(1)
      end
    end
    context 'PATCH #update' do
      before(:each) do
        Company.current_id = @company.id
        @issue_type = create(:issue_type, project: create(:project))
      end
      it 'should update issue_type in database' do
        xhr :patch, :update, id: @issue_type, issue_type: issue_type_params
        expect(assigns(:issue_type).name).to eq issue_type_params[:name]
        expect(assigns(:issue_type).project_id).to eq issue_type_params[:project_id]
      end
      it 'should not update scope of issue_type if some issues outside this scope using this' do
        @issue_type.issues << create(:issue, project: create(:project))
        xhr :patch, :update, id: @issue_type, issue_type: issue_type_params
        Company.current_id = @company.id
        expect(assigns(:issue_type).project_id).to_not eq issue_type_params[:project_id]
      end
    end
    context 'DELETE #destroy' do
      before(:each) do
        @issue_type = create(:issue_type)
        Company.current_id = @company.id
      end
      it 'should destroy issue_type in database' do
        expect do
          xhr :delete, :destroy, id: @issue_type.id
          Company.current_id = @company.id
        end.to change(IssueType, :count).by(-1)
      end
      it 'should not destroy issue_type if at least one issue is using it' do
        create(:issue, issue_type: @issue_type)
        expect do
          xhr :delete, :destroy, id: @issue_type.id
          Company.current_id = @company.id
        end.to_not change(IssueType, :count)
      end
    end
  end

  describe 'Authorization' do
    context 'When is an admin' do
      before(:each) do
        sign_in @admin
      end
      it 'should be able to index issue_types' do
        expect do
          get :index
        end.to_not raise_error
      end
      it 'should be able to new issue_type' do
        expect do
          xhr :get, :new
        end.to_not raise_error
      end
      it 'should be able to create issue_type' do
        expect do
          xhr :post, :create, issue_type: issue_type_params
        end.to_not raise_error
      end
      it 'should be able to update issue_type' do
        expect do
          xhr :put, :update, id: issue_type, issue_type: issue_type_params
        end.to_not raise_error
      end
      it 'should be able to destroy issue_type' do
        expect do
          xhr :delete, :destroy, id: issue_type
        end.to_not raise_error
      end
    end

    context 'When is a member' do
      before(:each) do
        sign_in @member
      end
      it 'should not be able to index issue_types' do
        expect(get(:index)).to have_http_status(404)
      end
      it 'should not be able to new issue_type' do
        expect(xhr(:get, :new)).to have_http_status(404)
      end
      it 'should not be able to create issue_type' do
        expect(xhr(:post, :create, issue_type: issue_type_params)).to have_http_status(404)
      end
      it 'should not be able to update issue_type' do
        expect(xhr(:put, :update, id: issue_type, issue_type: issue_type_params)).to have_http_status(404)
      end
      it 'should not be able to destroy issue_type' do
        expect(xhr(:delete, :destroy, id: issue_type)).to have_http_status(404)
      end
    end
  end
end
