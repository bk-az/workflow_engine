require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  subject(:ability) { Ability.new(user) }
  let(:user) { FactoryGirl.build(:user) }

  before(:each) do
    @admin = create(:admin)
    @member = create(:member)
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
    # context 'as member' do
    #   before(:each) do
    #     sign_in @member
    #   end
    #   it 'is not allowed to create new team so dont render new template' do
    #     # expect do
    #       get :new
    #     expect(response).to raise_exception(CanCan::AccessDenied)
    #     # assert ability.cannot?(:create, new)
    #   end
    # end
  end

  describe 'Get #show' do
    before :all do
      @team = FactoryGirl.create(:team)
    end
    context 'as admin' do 
      before(:each) do
        sign_in @admin
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

    context 'as member' do
      before(:each) do
        sign_in @member
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
  end

  describe 'POST #create' do
    before(:all) {
      FactoryGirl.create(:user)
    }
    context 'as admin allowed to create' do
      before(:each) do
        sign_in @admin
      end
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
    context 'as member not allowed to create' do
      before(:each) do
        sign_in @member
      end
      context 'with valid attributes' do
        it 'saves the new team in the database' do
          assert ability.cannot?(:create, @team)
        end
        it 'doesnt saves the invalid team in the database' do
          assert ability.cannot?(:destroy, FactoryGirl.attributes_for(:invalid_team))
        end
      end
    end
  end

  describe '#destroy' do
    before :all do
      @team = FactoryGirl.create(:team)
    end
    context 'as admin allowed to destroy' do
      before(:each) do
        sign_in @admin
      end
      it 'removes team from table' do
        expect { delete :destroy, id: @team }.to change { Team.count }.by(-1)
      end
    end
    context 'as member not allowed to destroy' do
      before(:each) do
        sign_in @member
      end
      it 'cannot removes team from table' do
        # expect { delete :destroy, id: @team }.to_not change { Team.count }
        assert ability.cannot?(:destroy, @team)
      end
    end
  end

  describe 'PUT update' do
    before :all do
      @team = FactoryGirl.create(:team)
    end

    context 'as admin allowed to update' do
      before(:each) do
        sign_in @admin
      end
      context 'valid attributes' do
        it 'locates the requested @team' do
          put :update, id: @team, team: FactoryGirl.attributes_for(:team)
          expect(assigns(:team)).to eq(@team)
        end

        it 'update attributes for valid team' do
          put :update, id: @team, team: FactoryGirl.attributes_for(
            :team,
            name: 'This is edited team'
          )
          @team.reload
          expect(@team.name).to eq('This is edited team')
        end

        it 'update attributes for invalid team' do
          put :update, id: @team, team: FactoryGirl.attributes_for(:invalid_team)
          @team.reload
          expect(@team.name).to_not eq(nil)
        end
      end
    end

    context 'as member not allowed to update' do
      before(:each) do
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
