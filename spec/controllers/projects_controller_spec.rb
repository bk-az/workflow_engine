require 'rails_helper'
require 'spec_helper'

RSpec.describe ProjectsController, type: :controller do
  before(:all) do
    @admin = create(:admin)
    @member = create(:member)
  end

  let(:project_attr) { FactoryGirl.attributes_for(:project) }
  let(:invalid_project_attr) { FactoryGirl.attributes_for(:invalid_project) }
  let(:project) { FactoryGirl.create(:project) }

  describe 'GET #index' do
    context 'Without signing in' do
      it 'should not be able to get all projects' do
        expect do
          get :index
        end.to raise_exception(CanCan::AccessDenied)
      end
    end

    context 'as a member' do
      before(:each) do
        sign_in @member
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
      @project = create(:project)
      @member.projects << @project
    end

    context 'Without signing in' do
      it 'should not be able to get all projects' do
        expect do
          get :show, id: @project
        end.to raise_exception(CanCan::AccessDenied)
      end
    end
    context 'as a member' do
      before(:each) do
        sign_in @member
      end
      it 'should assign the requested project to @project' do
        get :show, id: @project
        expect(assigns(:project)).to eq(@project)
      end
      it "should assign the requested project's issues to @issues" do
        get :show, id: @project
        expect(assigns(:issues)).to eq(@project.issues)
      end
      it 'should success and render to the :show template' do
        get :show, id: @project
        expect(response).to have_http_status(200)
        expect(response).to render_template :show
      end
    end
    context 'as a admin' do
      before(:each) do
        sign_in @admin
      end
      it 'should assign the requested project to @project' do
        get :show, id: project
        expect(assigns(:project)).to eq(project)
      end
      it "should assign the requested project's issues to @issues" do
        get :show, id: project
        expect(assigns(:issues)).to eq(project.issues)
      end
      it 'should success and render to the :show template' do
        get :show, id: project
        expect(response).to have_http_status(200)
        expect(response).to render_template :show
      end
    end
  end

  describe 'GET #new' do
    context 'Without signing in' do
      it 'should not be able to go to :new template' do
        expect do
          get :new
        end.to raise_exception(CanCan::AccessDenied)
      end
    end

    context 'as a member' do
      before(:each) do
        sign_in @member
      end
      it 'should not be able to go to :new template' do
        expect do
          get :new
        end.to raise_exception(CanCan::AccessDenied)
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

  describe 'POST #create' do
    context 'Without signing in' do
      it 'should not be able to create a project' do
        expect { post :create, project: project_attr }
          .to raise_exception(CanCan::AccessDenied)
      end
    end

    context 'For a Member' do
      before(:each) do
        sign_in @member
      end
      it 'should not be able to create a project' do
        expect { post :create, project: project_attr }
          .to raise_exception(CanCan::AccessDenied)
      end
    end

    context 'For an Administrator' do
      before(:each) do
        sign_in @admin
      end

      context 'with valid attributes' do
        it 'should save the new project in the database' do
          expect { post :create, project: project_attr }
            .to change(Project, :count).by(1)
          expect(flash[:notice]).to eq 'Successfully created a project.'
        end
        it "should redirect to that new project's page" do
          post :create, project: project_attr
          expect(response).to redirect_to Project.last
        end
      end

      context 'with invalid attributes' do
        it 'should not save the new project in the database' do
          expect do
            post :create, project: invalid_project_attr
          end.to_not change(Project, :count)
        end
        it 'should re-render the :new template' do
          post :create, project: invalid_project_attr
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'PUT update' do
    let(:edit_title) { 'Edit Test Proj' }
    let(:edit_description) { 'I am editing this test project.' }

    context 'Without signing in' do
      it 'should not be able to locate the project' do
        expect { put :update, id: project, project: project_attr }
          .to raise_exception(CanCan::AccessDenied)
      end
    end

    context 'For a Member' do
      before(:each) do
        sign_in @member
      end

      it 'should not be able to locate the project' do
        expect { put :update, id: project, project: project_attr }
          .to raise_exception(CanCan::AccessDenied)
      end
    end

    context 'For an Administrator' do
      before(:each) do
        sign_in @admin
      end

      context 'valid attributes' do
        it 'should locate the requested @project' do
          put :update, id: project, project: project_attr
          expect(assigns(:project)).to eq(project)
        end

        it "should change the @project's attributes" do
          put :update, id: project, project: FactoryGirl.attributes_for(
            :project, title: edit_title,
                      description: edit_description
          )
          project.reload
          expect(project.title).to eq(edit_title)
          expect(project.description).to eq(edit_description)
        end

        it 'should redirect to the updated project' do
          put :update, id: project, project: project_attr
          expect(response).to redirect_to @project
        end
      end

      context 'invalid attributes' do
        it 'should locate the requested @project' do
          put :update, id: project,
                       project: invalid_project_attr
          expect(assigns(:project)).to eq(project)
        end

        it "should not change @project's attributes" do
          put :update, id: project,
                       project: FactoryGirl.attributes_for(
                         :project, title: edit_title, description: nil
                       )
          project.reload
          expect(project.title).to_not eq(edit_title)
        end

        it 'should re-render the edit method' do
          put :update, id: project, project: FactoryGirl.attributes_for(
            :invalid_project
          )
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      @project = FactoryGirl.create(:project)
    end

    context 'Without Signing in' do
      it 'should not be able to destroy membership' do
        expect { delete :destroy, id: @project }
          .to raise_exception(CanCan::AccessDenied)
      end
    end

    context 'For a Member' do
      before(:each) do
        sign_in @member
      end
      it 'should not be able to delete a project' do
        expect { delete :destroy, id: @project }
          .to raise_exception(CanCan::AccessDenied)
      end
    end

    context 'For an Administrator' do
      before(:each) do
        sign_in @admin
      end
      it 'can delete a project' do
        expect { delete :destroy, id: @project }
          .to change(Project, :count).by(-1)
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
