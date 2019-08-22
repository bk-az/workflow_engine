require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
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
  describe 'GET #index' do
    context 'as member' do
      before(:each) do
        sign_in @member
      end
      it 'returns a success response' do
        get :index
        expect(response).to be_success
      end
    end
    context 'as admin' do
      before(:each) do
        sign_in @admin
      end
      it 'returns a success response' do
        get :index
        expect(response).to be_success
      end
    end
  end

  describe 'Get #new' do
    context 'as admin' do
      before(:each) do
        sign_in @admin
      end
      it 'is allowed to create new team so render new template' do
        get :new
        expect(response).to be_success
      end
    end
  end

  describe 'Get #show' do
    before :all do
      @team = create(:team, company: @company)
    end
    context 'as admin' do 
      before(:each) do
        sign_in @admin
      end
      it 'returns a success response' do
        get :show, id: @team.sequence_num
        expect(assigns(:team)).to eq(@team)
      end

      it 'should success and render to the :show template' do
        get :show, id: @team.sequence_num
        expect(response).to have_http_status(200)
        expect(response).to render_template :show
      end
    end

    context 'as member' do
      before(:each) do
        sign_in @member
      end
      it 'returns a success response' do
        get :show, id: @team.sequence_num
        expect(assigns(:team)).to eq(@team)
      end

      it 'should success and render to the :show template' do
        get :show, id: @team.sequence_num
        expect(response).to have_http_status(200)
        expect(response).to render_template :show
      end
    end
  end

  describe 'POST #create' do
    before(:all) do
      Company.current_id = @company.id
      FactoryGirl.create(:user)
    end
    context 'as admin allowed to create' do
      before(:each) do
        Company.current_id = @company.id
        sign_in @admin
      end
      context 'with valid/invalid attributes' do
        it 'create the valid team in the database by admin' do
          expect do
            post :create, team: attributes_for(:team)
            Company.current_id = @company.id
          end.to change(Team, :count).by(1)
        end
        it 'doesnt create the invalid team in the database by admin' do
          expect do
            post :create, team: attributes_for(:team, name: 'a')
            Company.current_id = @company.id
          end.to_not change(Team, :count)
        end
      end
    end
    context 'as member not allowed to create' do
      before(:each) do
        Company.current_id = @company.id
        sign_in @member
      end
      context 'with valid/invalid attributes' do
        it 'doesnt allow to create the valid team in the database by member' do
          assert ability.cannot?(:create, team: attributes_for(:team))
        end
        it 'doesnt allow to create the invalid team in the database by member' do
          assert ability.cannot?(:create, team: attributes_for(:team, name: 'a'))
        end
      end
    end
  end

  describe '#destroy' do
    before :all do
      @team = create(:team, company: @company)
    end
    context 'as admin allowed to destroy' do
      before(:each) do
        sign_in @admin
      end
      it 'removes team from table' do
        expect do
         delete :destroy, id: @team
         Company.current_id = @company.id
        end.to change { Team.count }.by(-1)
      end
    end
    context 'as member not allowed to destroy' do
      before(:each) do
        sign_in @member
      end
      it 'cannot removes team from table' do
        assert ability.cannot?(:destroy, @team)
      end
    end
  end

describe 'PUT update' do
  before :all do
    Company.current_id = @company.id
    @team = FactoryGirl.create(:team)
  end

  context 'as admin allowed to update' do
    before(:each) do
      Company.current_id = @company.id
      sign_in @admin
    end
    context 'valid/invalid attributes' do
      it 'locates the requested @team' do
        put :update, id: @team.sequence_num, team: FactoryGirl.attributes_for(:team)
        expect(assigns(:team)).to eq(@team)
      end

      it 'update attributes for valid team' do
        put :update, id: @team.sequence_num, team: attributes_for(:team, name: 'new')
        expect(assigns(:team).name).to eq('new')
      end

      it 'doesnt update attributes for invalid team' do
        put :update, id: @team.sequence_num, team: FactoryGirl.attributes_for(:team, name: '')
        expect(assigns(:team).errors).to_not be_empty
      end
    end
  end

  context 'as member not allowed to update' do
    before(:each) do
      Company.current_id = @company.id
      sign_in @member
    end
    it 'not allow member to update team' do
      assert ability.cannot?(:update, @team)
    end
  end
end

  context 'Routes testing' do
    it 'routes to #index' do
      expect(get: '/teams').to route_to('teams#index')
    end

    it 'routes to #show' do
      expect(get: '/teams/1').to route_to('teams#show', id: '1')
    end

    it 'routes to #new' do
      expect(get: '/teams/new').to route_to('teams#new')
    end

    it 'routes to #update via PUT' do
      expect(put: '/teams/1').to route_to('teams#update', id: '1')
    end
    it 'routes to #update via PATCH' do
      expect(patch: '/teams/1').to route_to('teams#update', id: '1')
    end
  end
end
