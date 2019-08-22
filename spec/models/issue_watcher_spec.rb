require 'rails_helper'

RSpec.describe IssueWatcher, type: :model do
  before(:all) do
    @company = FactoryGirl.create(:company)
    Company.current_id = @company.id
    @issue = create(:issue, company: @company)
  end

  before(:each) do
    Company.current_id = @company.id
  end

  context 'validation tests' do
    before(:all) do
      @issue_watcher = FactoryGirl.create(:issue_watcher, company: @company)
    end

    it 'ensures issue_id presence' do
      @issue_watcher.issue_id = ''
      expect(@issue_watcher.valid?).to eq false
    end

    it 'ensures watcher_id presence' do
      @issue_watcher.watcher_id = ''
      expect(@issue_watcher.valid?).to eq false
    end

    it 'ensures watcher_type presence' do
      @issue_watcher.watcher_type = ''
      expect(@issue_watcher.valid?).to eq false
    end
  end

  describe 'Method: search' do
    context 'with valid attributes' do
      let(:search_watcher_params) do
        { issue_id: @issue.id,
          watcher_search: 'member',
          watcher_type: 'User',
          watcher_action: 'create' }
      end

      it 'should return list of watchers for adding' do
        @watchers = IssueWatcher.find_watchers(search_watcher_params, @company)
        issue = Issue.find(search_watcher_params[:issue_id])
        watchers = User.where('first_name LIKE ?', "%#{search_watcher_params[:watcher_search]}%").where.not(id: issue.watcher_users.ids)
        expect(@watchers).to eq watchers
      end

      let(:search_watcher_params) do
        { issue_id: @issue.id,
          watcher_search: 'member',
          watcher_type: 'User',
          watcher_action: 'destroy' }
      end

      it 'should return list of watchers for removing' do
        @watchers = IssueWatcher.find_watchers(search_watcher_params, @company)
        issue = Issue.find(search_watcher_params[:issue_id])
        watchers = User.where('first_name LIKE ?', "%#{search_watcher_params[:watcher_search]}%").where(id: issue.watcher_users.ids)
        expect(@watchers).to eq watchers
      end
    end

    context 'with invalid attributes' do
      let(:search_watcher_params) do
        { issue_id: @issue.id,
          watcher_search: 'member',
          watcher_type: 'User',
          watcher_action: nil }
      end

      it 'should not return list of watchers for adding' do
        @watchers = IssueWatcher.find_watchers(search_watcher_params, @company)
        issue = Issue.find(search_watcher_params[:issue_id])
        watchers = User.where('first_name LIKE ?', "%#{search_watcher_params[:watcher_search]}%").where.not(id: issue.watcher_users.ids)
        expect(@watchers).to eq watchers
      end

      it 'should not return list of watchers for removing' do
        @watchers = IssueWatcher.find_watchers(search_watcher_params, @company)
        issue = Issue.find(search_watcher_params[:issue_id])
        watchers = User.where('first_name LIKE ?', "%#{search_watcher_params[:watcher_search]}%").where(id: issue.watcher_users.ids)
        expect(@watchers).to eq watchers
      end
    end
  end
end
