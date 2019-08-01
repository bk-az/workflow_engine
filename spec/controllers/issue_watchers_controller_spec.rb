require 'rails_helper'

RSpec.describe IssueWatchersController, type: :controller do
  before(:each) do
    @admin = create(:admin)
    @member = create(:member)
    sign_in @member
  end

  before :all do
    @issue = create(:issue)
    @watcher = create(:user)
  end

  let(:issue) { FactoryGirl.create(:issue) }
  let(:user)  { FactoryGirl.create(:user) }
  let(:team)  { FactoryGirl.create(:team) }

  let(:user_watcher_params) do
    { issue_id: issue.id,
      watcher_id: user.id,
      watcher_type: user.class.name }
  end
  let(:team_watcher_params) do
    { issue_id: issue.id,
      watcher_id: team.id,
      watcher_type: team.class.name }
  end

  describe 'POST #create_watcher' do
    context 'with valid attributes' do
      it 'should create a new issue-watcher for user in the database' do
        expect do
          xhr :post, :create_watcher, user_watcher_params
        end.to change(IssueWatcher, :count).by(1)
      end

      it 'should create a new issue-watcher for team in the database' do
        expect do
          xhr :post, :create_watcher, team_watcher_params
        end.to change(IssueWatcher, :count).by(1)
      end

      it 'should render create_watcher template' do
        xhr :post, :create_watcher, user_watcher_params
        expect(response).to render_template(:create_watcher)
      end
    end

    context 'with invalid attributes' do
      let(:user_watcher_params) do
        { issue_id: issue.id,
          watcher_id: user.id,
          watcher_type: nil }
      end
      it 'should not create a new issue-watcher' do
        expect do
          xhr :post, :create_watcher, user_watcher_params
        end.to_not change(IssueWatcher, :count)
      end
    end
  end

  describe 'POST #create_watcher_by_admin' do
    before(:each) do
      sign_in @admin
    end
    context 'with valid attributes' do
      it 'should create a new issue-watcher for user in the database' do
        expect do
          xhr :post, :create_watcher_by_admin, user_watcher_params
        end.to change(IssueWatcher, :count).by(1)
      end

      it 'should create a new issue-watcher for team in the database' do
        expect do
          xhr :post, :create_watcher_by_admin, team_watcher_params
        end.to change(IssueWatcher, :count).by(1)
      end

      it 'should render create_watcher_by_admin template' do
        xhr :post, :create_watcher_by_admin, user_watcher_params
        expect(response).to render_template(:create_watcher_by_admin)
      end
    end

    context 'with invalid attributes' do
      let(:user_watcher_params) do
        { issue_id: issue.id,
          watcher_id: user.id,
          watcher_type: nil }
      end
      it 'should not create a new issue-watcher' do
        expect do
          xhr :post, :create_watcher_by_admin, user_watcher_params
        end.to_not change(IssueWatcher, :count)
      end
    end
  end

  describe 'DELETE destroy_watcher' do
    before :each do
      @issue_watcher = build(:issue_watcher)
      @issue_watcher.issue_id = @issue.id
      @issue_watcher.watcher_id = @watcher.id
      @issue_watcher.watcher_type = @watcher.class.name
      @issue_watcher.save!
    end
    let(:watcher_params) do
      { issue_id: @issue_watcher.issue_id,
        watcher_id: @issue_watcher.watcher_id,
        watcher_type: @issue_watcher.watcher_type }
    end

    it 'should delete the issue-watcher' do
      expect { xhr :post, :destroy_watcher, watcher_params }
        .to change(IssueWatcher, :count).by(-1)
    end

    it 'should render destroy_watcher template' do
      xhr :post, :destroy_watcher, watcher_params
      expect(response).to render_template(:destroy_watcher)
    end
  end

  describe 'DELETE destroy_watcher_by_admin' do
    before(:each) do
      sign_in @admin
      @issue_watcher = build(:issue_watcher)
      @issue_watcher.issue_id = @issue.id
      @issue_watcher.watcher_id = @watcher.id
      @issue_watcher.watcher_type = @watcher.class.name
      @issue_watcher.save!
    end
    let(:watcher_params) do
      { issue_id: @issue_watcher.issue_id,
        watcher_id: @issue_watcher.watcher_id,
        watcher_type: @issue_watcher.watcher_type }
    end

    it 'should delete the issue-watcher' do
      expect { xhr :post, :destroy_watcher_by_admin, watcher_params }
        .to change(IssueWatcher, :count).by(-1)
    end

    it 'should render destroy_watcher template' do
      xhr :post, :destroy_watcher_by_admin, watcher_params
      expect(response).to render_template(:destroy_watcher_by_admin)
    end
  end
end
