require 'rails_helper'

RSpec.describe IssueWatcher, type: :model do
  before(:all) do
    @company = FactoryGirl.create(:company)
    @issue = create(:issue, company: @company)
    @watcher = create(:user, company: @company)
  end

  before(:each) do
    Company.current_id = @company.id
  end

  let(:issue) { FactoryGirl.create(:issue, company: @company) }
  let(:user)  { FactoryGirl.create(:user, company: @company) }
  let(:team)  { FactoryGirl.create(:team, company: @company) }

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

  describe 'Method: #add_watcher' do
    context 'with valid attributes' do
      it 'should create a new issue-watcher for user in the database' do
        expect do
          IssueWatcher.add_watcher(user_watcher_params)
        end.to change(IssueWatcher, :count).by(1)
      end

      it 'should create a new issue-watcher for team in the database' do
        expect do
          IssueWatcher.add_watcher(user_watcher_params)
        end.to change(IssueWatcher, :count).by(1)
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
          IssueWatcher.add_watcher(user_watcher_params)
        end.to_not change(IssueWatcher, :count)
      end
    end
  end

  describe 'Method: remove_watcher' do
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
      expect do
        IssueWatcher.remove_watcher(watcher_params)
      end.to change(IssueWatcher, :count).by(-1)
    end

    context 'with invalid attributes' do
      let(:watcher_params) do
        { issue_id: @issue_watcher.issue_id,
          watcher_id: @issue_watcher.watcher_id,
          watcher_type: nil }
      end
      it 'should not remove issue-watcher' do
        expect do
          IssueWatcher.remove_watcher(watcher_params)
        end.to_not change(IssueWatcher, :count)
      end
    end
  end

  describe 'GET search_watcher as @admin' do
    context 'with valid attributes' do
      let(:search_watcher_params) do
        { issue_id: @issue.id,
          watcher_search: 'member',
          watcher_type: 'User' }
      end
      it 'should return list of watchers to add' do
        @watchers = IssueWatcher.get_watchers_to_add(search_watcher_params)
        issue = Issue.find(search_watcher_params[:issue_id])
        watchers = User.where('first_name LIKE ?', "%#{search_watcher_params[:watcher_search]}%").where.not(id: issue.watcher_users.ids)
        expect(@watchers).to eq watchers
      end

      it 'should return list of watchers to remove' do
        @watchers = IssueWatcher.get_watchers_to_remove(search_watcher_params)
        issue = Issue.find(search_watcher_params[:issue_id])
        watchers = User.where('first_name LIKE ?', "%#{search_watcher_params[:watcher_search]}%").where(id: issue.watcher_users.ids)
        expect(@watchers).to eq watchers
      end
    end

    context 'with invalid attributes' do
      let(:search_watcher_params) do
        { issue_id: @issue.id,
          watcher_search: 'member',
          watcher_type: nil }
      end
      it 'should return list of watchers to add' do
        @watchers = IssueWatcher.get_watchers_to_add(search_watcher_params)
        issue = Issue.find(search_watcher_params[:issue_id])
        watchers = User.where('first_name LIKE ?', "%#{search_watcher_params[:watcher_search]}%").where.not(id: issue.watcher_users.ids)
        expect(@watchers).to_not eq watchers
      end

      it 'should return list of watchers to remove' do
        @watchers = IssueWatcher.get_watchers_to_remove(search_watcher_params)
        issue = Issue.find(search_watcher_params[:issue_id])
        watchers = User.where('first_name LIKE ?', "%#{search_watcher_params[:watcher_search]}%").where(id: issue.watcher_users.ids)
        expect(@watchers).to_not eq watchers
      end
    end
  end
end