require 'rails_helper'
require 'spec_helper'

RSpec.describe ProjectsController, type: :controller do
  subject(:ability) { Ability.new(user) }
  let(:user) { FactoryGirl.build(:user) }

  before(:all) do
    @company = create(:company)
    Company.current_id = @company.id
    @admin = create(:admin, company: @company)
    @member = create(:member, company: @company)
  end
  before(:each) do
    @request.host = "#{@company.subdomain}.lvh.me:3000"
    Company.current_id = @company.id
  end
  let(:project_attr) { FactoryGirl.attributes_for(:project) }
  let(:invalid_project_attr) { FactoryGirl.attributes_for(:invalid_project) }
  let(:project) { FactoryGirl.create(:project) }

  describe 'GET #index' do
    context 'as a member' do
      before(:each) do
        sign_in @member
      end
      it 'should success and render to :index view' do
        get :index
        expect(response).to have_http_status(200)
        expect(response).to render_template(:index)
      end
    end
    context 'as an administrator' do
      before(:each) do
        sign_in @admin
      end
      it 'should success and render to :index view' do
        get :index
        expect(response).to have_http_status(200)
        expect(response).to render_template(:index)
      end
      it 'should populate an array of projects' do
        get :index
        expect(assigns(:projects)).to eq([project])
      end
    end
  end

  describe 'GET #show' do
    before(:all) do
      Company.current_id = @company.id
      @project = create(:project, company: @company)
      @member.projects << @project
    end
    context 'as a member' do
      before(:each) do
        sign_in @member
      end
      it 'should assign the requested project to @project' do
        get :show, id: @project.sequence_num
        expect(assigns(:project)).to eq(@project)
      end
      it "should assign the requested project's issues to @issues" do
        get :show, id: @project.sequence_num
        expect(assigns(:issues)).to eq(@project.issues)
      end
      it "should assign the requested project's issues types to @issue_types" do
        get :show, id: @project.sequence_num
        expect(assigns(:issue_types)).to eq(@company.issue_types.for_projects(@project))
      end
      it "should assign the requested project's issues states to @issue_states" do
        get :show, id: @project.sequence_num
        expect(assigns(:issue_states)).to eq(@company.issue_states.for_projects(@project))
      end
      it 'should success and render to the :show template' do
        get :show, id: @project.sequence_num
        expect(response).to have_http_status(200)
        expect(response).to render_template :show
      end
    end
    context 'as a admin' do
      before(:each) do
        sign_in @admin
      end
      it 'should assign the requested project to @project' do
        get :show, id: @project.sequence_num
        expect(assigns(:project)).to eq(@project)
      end
      it "should assign the requested project's issues to @issues" do
        get :show, id: @project.sequence_num
        expect(assigns(:issues)).to eq(@project.issues)
      end
      it "should assign the requested project's issues types to @issue_types" do
        get :show, id: @project.sequence_num
        expect(assigns(:issue_types)).to eq(@company.issue_types.for_projects(@project))
      end
      it "should assign the requested project's issues states to @issue_states" do
        get :show, id: @project.sequence_num
        expect(assigns(:issue_states)).to eq(@company.issue_states.for_projects(@project))
      end
      it 'should success and render to the :show template' do
        get :show, id: @project.sequence_num
        expect(response).to have_http_status(200)
        expect(response).to render_template :show
      end
    end
  end

  describe 'GET #new' do
    before(:all) do
      Company.current_id = @company.id
      @project = create(:project, company: @company)
      @member.projects << @project
    end

    context 'as a member' do
      before(:each) do
        sign_in @member
      end
      it 'should not be able to go to :new template' do
        assert ability.cannot?(:new, @project)
      end
    end
    context 'as an administrator' do
      before(:each) do
        sign_in @admin
      end
      it 'should render the :new template' do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'yields html' do
      expect { respond_to(:html) }
    end
  end

  describe 'POST #create' do
    before(:all) do
      Company.current_id = @company.id
      @project = create(:project, company: @company)
      FactoryGirl.create(:user)
      @member.projects << @project
    end

    context 'For a Member' do
      before(:each) do
        Company.current_id = @company.id
        sign_in @member
      end
      it 'should not be able to create a project' do
        assert ability.cannot?(:create, @project)
      end
    end

    context 'For an Administrator' do
      before(:each) do
        Company.current_id = @company.id
        sign_in @admin
      end

      context 'with valid attributes' do
        it 'should save the new project in the database' do
          expect do
            post :create, project: attributes_for(:project)
            Company.current_id = @company.id
          end.to change(Project, :count).by(1)
        end
        # it "should redirect to that new project's page" do
        #   post :create, project: project_attr
        #   expect(response).to redirect_to Project.last
        # end
      end

      context 'with invalid attributes' do
        it 'should not save the new project in the database' do
          expect do
            post :create, project: attributes_for(:project, title: 'a')
            Company.current_id = @company.id
          end.to_not change(Project, :count)
        end
        it 'should re-render the :new template' do
          post :create, project: attributes_for(:project, title: 'a')
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'PUT update' do
    before(:all) do
      Company.current_id = @company.id
      @project = create(:project, company: @company)
      FactoryGirl.create(:user)
      @member.projects << @project
    end
    let(:edited_title) { 'Edit Test Proj' }
    let(:edited_description) { 'I am editing this test project.' }

    context 'For a Member' do
       before(:each) do
        Company.current_id = @company.id
        sign_in @member
      end

      it 'should not be able to update the project' do
        assert ability.cannot?(:update, @project)
      end
    end

    context 'For an Administrator' do
      before(:each) do
        Company.current_id = @company.id
        sign_in @admin
      end

      context 'valid attributes' do
        it 'should locate the requested @project' do
          put :update, id: project.sequence_num, project: attributes_for(:project)
          expect(assigns(:project)).to eq(project)
        end

        it "should change the @project's attributes" do
          put :update, id: project.sequence_num, project: attributes_for(:project, title: edited_title,description: edited_description)
          expect(assigns(:project).title).to eq(edited_title)
          expect(assigns(:project).description).to eq(edited_description)
        end

        it 'should redirect to the updated project' do
          put :update, id: project, project: attributes_for(:project)
          expect(response).to redirect_to project
        end
      end

      context 'invalid attributes' do
        it 'should locate the requested @project' do
          put :update, id: project,
                       project: project_attr
          expect(assigns(:project)).to eq(project)
        end

        it "should not change @project's attributes" do
          put :update, id: project.sequence_num, project: FactoryGirl.attributes_for(:project, title: '')
          expect(assigns(:project).errors).to_not be_empty
        end

        it 'should re-render the edit method' do
          put :update, id: project.sequence_num, project: FactoryGirl.attributes_for(:project, title: '')
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      @project = FactoryGirl.create(:project)
    end

    context 'For a Member' do
      before(:each) do
        sign_in @member
      end
       it 'should not be able to delete the project' do
        assert ability.cannot?(:delete, @project)
      end
    end

    context 'For an Administrator' do
      before(:each) do
        sign_in @admin
      end
      it 'can delete a project' do
        if @project.destroy
          expect { @project.reload }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      it 'should redirect to projects#index' do
        delete :destroy, id: @project
        expect(response).to redirect_to projects_url
      end
    end
  end
end

RSpec.describe ProjectsController, type: :routing do
  describe 'routing' do
    it 'should route to #index' do
      expect(get: '/projects').to route_to('projects#index')
    end

    it 'should route to #show' do
      expect(get: '/projects/1').to route_to('projects#show', id: '1')
    end

    it 'should route to #new' do
      expect(get: '/projects/new').to route_to('projects#new')
    end

    it 'should route to #update via PUT' do
      expect(put: '/projects/1').to route_to('projects#update', id: '1')
    end

    it 'should route to #update via PATCH' do
      expect(patch: '/projects/1').to route_to('projects#update', id: '1')
    end
  end
end
