require 'rails_helper'

RSpec.describe TeamsController, type: :controller do

  before(:each) do
    @admin = create(:admin)
    @member = create(:member)
    sign_in @member
  end
  context 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_success
    end
  end


  context 'Get #new' do
    it 'it render new template' do
      get :new
      expect(response).to be_success
    end
  end


  describe 'Get #show' do
    before :all do
      @team = FactoryGirl.create(:team)
    end

    it 'returns a success response' do
      get :show, id: @team
      expect(assigns(:team)).to eq(@team)
    end

    it 'should success and render to the :show template' do
      get :show, id: FactoryGirl.create(:team)
      expect(response).to have_http_status(200)
      expect(response).to render_template :show
    end
  end


  context 'POST #create' do
    before(:all) { 
      FactoryGirl.create(:user)
    }
    context 'with valid attributes' do
      it 'saves the new team in the database' do
        expect { post :create, team: FactoryGirl.attributes_for(:team) }
          .to change(Team, :count).by(1)
      end
      it 'doesnt saves the invalid team in the database' do
        expect { post :create, team: FactoryGirl.attributes_for(:invalid_team) }
          .to_not change(Team, :count)
      end
    end
  end

  describe '#destroy' do
    before :all do
      @team = FactoryGirl.create(:team)
    end
    it 'removes team from table' do
      expect { delete :destroy, id: @team }.to change { Team.count }.by(-1)
    end
  end

  describe 'PUT update' do
    before :all do
      @team = FactoryGirl.create(:team)
    end

    context 'valid attributes' do
      it 'locates the requested @team' do
        put :update, id: @team, team: FactoryGirl.attributes_for(:team)
        expect(assigns(:team)).to eq(@team)
      end

      it "update attributes for valid team" do
        put :update, id: @team, team: FactoryGirl.attributes_for(
          :team,
          name: 'This is edited team',
        )
        @team.reload
        expect(@team.name).to eq('This is edited team')
      end

      it "update attributes for invalid team" do
        put :update, id: @team, team: FactoryGirl.attributes_for(:invalid_team)
        @team.reload
        expect(@team.name).to_not eq(nil)
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
