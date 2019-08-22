require 'rails_helper'

RSpec.describe IssueWatchersController, type: :controller do
  before(:all) do
    @company = FactoryGirl.create(:company)
    Company.current_id = @company.id
    @admin = FactoryGirl.create(:admin, company: @company)
    @member = FactoryGirl.create(:member, company: @company)
    @project = create(:project, company: @company)
    @issue = create(:issue, company: @company, project: @project)
    @watcher = create(:user, company: @company)
    @watcher.projects << @issue.project
  end

  before(:each) do
    @request.host = "#{@company.subdomain}.lvh.me:3000"
    Company.current_id = @company.id
    sign_in @watcher
  end

  let(:issue) { FactoryGirl.create(:issue, company: @company) }
  let(:team)  { FactoryGirl.create(:team, company: @company) }

  let(:user_watcher_params) do
    { issue_id: issue.id,
      watcher_id: @watcher.id,
      watcher_type: @watcher.class.name }
  end
  let(:team_watcher_params) do
    { issue_id: issue.id,
      watcher_id: team.id,
      watcher_type: team.class.name }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'should create a new issue-watcher for user in the database' do
        expect do
          xhr :post, :create, user_watcher_params
          Company.current_id = @company.id
        end.to change(IssueWatcher, :count).by(1)
      end

      it 'should not create a new issue-watcher for team in the database' do
        expect do
          xhr :post, :create, team_watcher_params
          Company.current_id = @company.id
        end.to_not change(IssueWatcher, :count)
      end

      it 'should render create template' do
        xhr :post, :create, user_watcher_params
        Company.current_id = @company.id
        expect(response).to render_template(:create)
      end
    end

    context 'with invalid attributes' do
      let(:user_watcher_params) do
        { issue_id: issue.id,
          watcher_id: @watcher.id,
          watcher_type: nil }
      end
      it 'should not create a new issue-watcher' do
        expect do
          xhr :post, :create, user_watcher_params
          Company.current_id = @company.id
        end.to_not change(IssueWatcher, :count)
      end
    end
  end

  describe 'POST #create as @admin' do
    before(:each) do
      sign_in @admin
    end
    context 'with valid attributes' do
      it 'should create a new issue-watcher for user in the database' do
        expect do
          xhr :post, :create, user_watcher_params
          Company.current_id = @company.id
        end.to change(IssueWatcher, :count).by(1)
      end

      it 'should create a new issue-watcher for team in the database' do
        expect do
          xhr :post, :create, team_watcher_params
          Company.current_id = @company.id
        end.to change(IssueWatcher, :count).by(1)
      end

      it 'should render create template' do
        xhr :post, :create, user_watcher_params
        Company.current_id = @company.id
        expect(response).to render_template(:create)
      end
    end

    context 'with invalid attributes' do
      let(:user_watcher_params) do
        { issue_id: issue.id,
          watcher_id: @watcher.id,
          watcher_type: nil }
      end
      it 'should not create a new issue-watcher' do
        expect do
          xhr :post, :create, user_watcher_params
          Company.current_id = @company.id
        end.to_not change(IssueWatcher, :count)
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      @issue_watcher = build(:issue_watcher, company: @company)
      @issue_watcher.issue_id = @issue.id
      @issue_watcher.watcher_id = @watcher.id
      @issue_watcher.watcher_type = @watcher.class.name
      @issue_watcher.save!
    end

    it 'should render destroy template' do
      xhr :delete, :destroy, id: @issue_watcher.id
      expect(response).to render_template(:destroy)
    end

    it 'should delete the issue-watcher' do
      expect do
        xhr :delete, :destroy, id: @issue_watcher.id
        Company.current_id = @company.id
      end.to change(IssueWatcher, :count).by(-1)
    end
  end

  describe 'DELETE destroy as @admin' do
    before(:each) do
      sign_in @admin
      @issue_watcher = build(:issue_watcher, company: @company)
      @issue_watcher.issue_id = @issue.id
      @issue_watcher.watcher_id = @watcher.id
      @issue_watcher.watcher_type = @watcher.class.name
      @issue_watcher.save!
    end

    it 'should delete the issue-watcher' do
      expect do
        xhr :delete, :destroy, id: @issue_watcher.id
        Company.current_id = @company.id
      end.to change(IssueWatcher, :count).by(-1)
    end

    it 'should render destroy template' do
      xhr :delete, :destroy, id: @issue_watcher.id
      Company.current_id = @company.id
      expect(response).to render_template(:destroy)
    end
  end

  describe 'GET search_watcher as @admin' do
    before(:each) do
      sign_in @admin
    end

    context 'with valid attributes' do
      let(:search_watcher_params) do
        { issue_id: @issue.id,
          watcher_search: 'member',
          watcher_type: 'User',
          watcher_action: 'create' }
      end

      it 'should return list of watchers to add' do
        xhr :get, :search, search_watcher_params
        Company.current_id = @company.id
        issue = Issue.find(search_watcher_params[:issue_id])
        watchers = User.where('first_name LIKE ?', "%#{search_watcher_params[:watcher_search]}%").where.not(id: issue.watcher_users.ids)
        expect(assigns(:watchers)).to eq watchers
      end

      let(:search_watcher_params) do
        { issue_id: @issue.id,
          watcher_search: 'member',
          watcher_type: 'User',
          watcher_action: 'destroy' }
      end

      it 'should return list of watchers to remove' do
        xhr :get, :search, search_watcher_params
        Company.current_id = @company.id
        issue = Issue.find(search_watcher_params[:issue_id])
        watchers = User.where('first_name LIKE ?', "%#{search_watcher_params[:watcher_search]}%").where(id: issue.watcher_users.ids)
        expect(assigns(:watchers)).to eq watchers
      end
    end

    context 'with invalid attributes' do
      let(:search_watcher_params) do
        { issue_id: @issue.id,
          watcher_search: 'member',
          watcher_type: nil }
      end

      it 'should return list of watchers to add' do
        xhr :get, :search, search_watcher_params
        Company.current_id = @company.id
        issue = Issue.find(search_watcher_params[:issue_id])
        watchers = User.where('first_name LIKE ?', "%#{search_watcher_params[:watcher_search]}%").where.not(id: issue.watcher_users.ids)
        expect(assigns(:watchers)).to_not eq watchers
      end

      it 'should return list of watchers to remove' do
        xhr :get, :search, search_watcher_params
        Company.current_id = @company.id
        issue = Issue.find(search_watcher_params[:issue_id])
        watchers = User.where('first_name LIKE ?', "%#{search_watcher_params[:watcher_search]}%").where(id: issue.watcher_users.ids)
        expect(assigns(:watchers)).to_not eq watchers
      end
    end
  end
end
