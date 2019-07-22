require 'rails_helper'
require 'spec_helper'

RSpec.describe ProjectsController, type: :controller do
  describe 'GET #index' do
    it 'populates an array of projects' do
      @project = FactoryGirl.create(:project)
      get :index
      expect(assigns(:projects)).to eq([@project])
    end

    it 'should success and render to :index view' do
      get :index
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before :all do
      @project = FactoryGirl.create(:project)
    end
    it 'assigns the requested project to @project' do
      get :show, id: @project
      expect(assigns(:project)).to eq(@project)
    end
    it "assigns the requested project's issues to @issues" do
      get :show, id: @project
      expect(assigns(:issues)).to eq(@project.issues)
    end
    it 'should success and render to the :show template' do
      get :show, id: FactoryGirl.create(:project)
      expect(response).to have_http_status(200)
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'renders the :new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new project in the database' do
        expect { post :create, project: FactoryGirl.attributes_for(:project) }
          .to change(Project, :count).by(1)
        expect(flash[:notice]).to eq 'Successfully created a project.'
      end
      it "redirects to that new project's page" do
        post :create, project: FactoryGirl.attributes_for(:project)
        expect(response).to redirect_to Project.last
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new project in the database' do
        expect do
          post :create, project: FactoryGirl.attributes_for(:invalid_project)
        end.to_not change(Project, :count)
      end
      it 're-renders the :new template' do
        post :create, project: FactoryGirl.attributes_for(:invalid_project)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT update' do
    before :all do
      @project = FactoryGirl.create(:project)
    end

    context 'valid attributes' do
      it 'locates the requested @project' do
        put :update, id: @project, project: FactoryGirl.attributes_for(:project)
        expect(assigns(:project)).to eq(@project)
      end

      it "changes @project's attributes" do
        put :update, id: @project, project: FactoryGirl.attributes_for(
          :project, title: 'Edit Test Proj',
                    description: 'I am editing this test project.'
        )
        @project.reload
        expect(@project.title).to eq('Edit Test Proj')
        expect(@project.description).to eq('I am editing this test project.')
      end

      it 'redirects to the updated project' do
        put :update, id: @project, project: FactoryGirl.attributes_for(:project)
        expect(response).to redirect_to @project
      end
    end

    context 'invalid attributes' do
      it 'locates the requested @project' do
        put :update, id: @project,
                     project: FactoryGirl.attributes_for(:invalid_project)
        expect(assigns(:project)).to eq(@project)
      end

      it "does not change @project's attributes" do
        put :update, id: @project,
                     project: FactoryGirl.attributes_for(
                       :project, title: 'Edit Test Proj', description: nil
                     )
        @project.reload
        expect(@project.title).to_not eq('Edit Test Proj')
      end

      it 're-renders the edit method' do
        put :update, id: @project, project: FactoryGirl.attributes_for(
          :invalid_project
        )
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      @project = FactoryGirl.create(:project)
    end

    it 'deletes the contact' do
      expect { delete :destroy, id: @project }
        .to change(Project, :count).by(-1)
    end

    it 'redirects to contacts#index' do
      delete :destroy, id: @project
      expect(response).to redirect_to projects_url
    end
  end
end

RSpec.describe ProjectsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/projects').to route_to('projects#index')
    end

    it 'routes to #show' do
      expect(get: '/projects/1').to route_to('projects#show', id: '1')
    end

    it 'routes to #new' do
      expect(get: '/projects/new').to route_to('projects#new')
    end

    it 'routes to #update via PUT' do
      expect(put: '/projects/1').to route_to('projects#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/projects/1').to route_to('projects#update', id: '1')
    end
  end
end
