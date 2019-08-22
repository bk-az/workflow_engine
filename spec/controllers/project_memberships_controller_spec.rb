require 'rails_helper'

RSpec.describe ProjectMembershipsController, type: :controller do
  before(:all) do
    @company = create(:company)
    @admin = create(:admin, company: @company)
    @member = create(:member, company: @company)
  end

  before(:each) do
    @request.host = "#{@company.subdomain}.lvh.me:3000"
    Company.current_id = @company.id
  end

  let(:project) { create(:project, company: @company) }
  let(:user)    { create(:user, company: @company) }
  let(:team)    { create(:team, company: @company) }

  let(:user_membership_params) do
    { project_member_id: user.id,
      project_member_type: user.class.name }
  end
  let(:team_membership_params) do
    { project_member_id: team.id,
      project_member_type: team.class.name }
  end

  describe 'GET #index' do
    context 'With a Signed in user' do
      before(:each) do
        sign_in @member
      end
      context 'Not a member of current project' do
        it 'should not success and render to :index view' do
          expect(get(:index, project_id: project.sequence_num)).to have_http_status(404)
        end
      end
      context 'As a member of current project' do
        before(:all) do
          Company.current_id = @company.id
          @project = create(:project)
          @member.projects << @project
        end
        it 'should success and render to :index view' do
          get :index, project_id: @project.sequence_num
          expect(response).to have_http_status(200)
          expect(response).to render_template(:index)
        end
        it 'project should have current user as a member' do
          get :index, project_id: @project.sequence_num
          Company.current_id = @company.id
          expect(assigns(:users)).to eq [@member]
        end
        it 'project should have no teams' do
          get :index, project_id: @project.sequence_num
          expect(assigns(:teams)).to eq []
        end
        it 'should assign project to current project' do
          get :index, project_id: @project.sequence_num
          expect(assigns(:project)).to eq @project
        end
      end
      context 'As a member of team which is a member of current project' do
        before(:all) do
          Company.current_id = @company.id
          @project = create(:project, company: @company)
          @team = create(:team, company: @company)
          @team.users << @member
          @team.projects << @project
        end
        it 'should success and render to :index view' do
          get :index, project_id: @project.sequence_num
          expect(response).to have_http_status(200)
          expect(response).to render_template(:index)
        end
        it 'project should not have any users as a member' do
          get :index, project_id: @project.sequence_num
          expect(assigns(:users)).to eq []
        end
        it 'project should have current team as member' do
          get :index, project_id: @project.sequence_num
          Company.current_id = @company.id
          expect(assigns(:teams)).to eq [@team]
        end
        it 'should assign project to current project' do
          get :index, project_id: @project.sequence_num
          expect(assigns(:project)).to eq @project
        end
      end
    end
  end

  describe 'POST #create' do
    context 'For a Member' do
      before(:each) do
        sign_in @member
      end
      it 'should not be able to create membership' do
        expect(xhr(:post, :create, project_id: project.sequence_num, project_membership: user_membership_params)).to have_http_status(404)
      end
    end
    context 'For an Administrator' do
      before(:each) do
        sign_in @admin
      end
      context 'with valid attributes' do
        it 'should create a new project-membership for user in the database' do
          expect do
            xhr :post, :create, project_id: project.sequence_num, project_membership: user_membership_params
            Company.current_id = @company.id
          end.to change(ProjectMembership, :count).by(1)
        end

        it 'should create a new project-membership for team in the database' do
          expect do
            xhr :post, :create, project_id: project.sequence_num, project_membership: team_membership_params
            Company.current_id = @company.id
          end.to change(ProjectMembership, :count).by(1)
        end

        it 'should render create template' do
          xhr :post, :create, project_id: project.sequence_num, project_membership: user_membership_params
          expect(response).to render_template(:create)
        end
      end

      context 'with invalid attributes' do
        let(:user_membership_params) do
          { project_member_id: nil,
            project_member_type: user.class.name }
        end
        it 'should not create a new project-membership' do
          expect do
            xhr :post, :create, project_id: project.sequence_num, project_membership: user_membership_params
            Company.current_id = @company.id
          end.to_not change(ProjectMembership, :count)
        end
      end

      context 'variable assignments' do
        before :each do
          xhr :post, :create, project_id: project.sequence_num, project_membership: user_membership_params
        end
        it 'should assign project instance variable to current project' do
          expect(assigns(:project)).to eq project
        end

        it 'should assign project_member instance variable to current user' do
          expect(assigns(:project_member)).to eq user
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @project_membership = create(:project_membership)
    end

    context 'For a Member' do
      before(:each) do
        sign_in @member
      end
      it 'should not be able to destroy membership' do
        expect(xhr(:delete, :destroy, id: @project_membership)).to have_http_status(404)
      end
    end

    context 'For an Administrator' do
      before(:each) do
        sign_in @admin
      end
      it 'should delete the project-membership' do
        expect do
          xhr :delete, :destroy, id: @project_membership
          Company.current_id = @company.id
        end.to change(ProjectMembership, :count).by(-1)
      end

      it 'should render destroy template' do
        xhr :delete, :destroy, id: @project_membership
        expect(response).to render_template(:destroy)
      end
    end
  end

  describe 'GET #search' do
    before(:all) do
      Company.current_id = @company.id
      @project = create(:project)
    end

    let(:search_params) do
      { term: 'me',
        member_type: 'User',
        project_id: @project.id }
    end

    context 'For a Member' do
      before(:each) do
        sign_in @member
      end
      it 'should not be able to search members' do
        expect(xhr(:get, :search, search_params)).to have_http_status(404)
      end
    end

    context 'For an Administrator' do
      before(:each) do
        sign_in @admin
      end

      it 'should be able to search members' do
        expect do
          xhr :get, :search, search_params
        end.to_not raise_error
      end

      it 'should return member names and ids' do
        xhr :get, :search, search_params
        Company.current_id = @company.id
        member_names_ids = ProjectMembership.autocomplete_member(
          search_params[:member_type], search_params[:term], @project
        )
        expect(assigns(:search_results)).to eq member_names_ids
      end
    end
  end
end
