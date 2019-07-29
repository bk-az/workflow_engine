class IssueWatchersController < ApplicationController
  def create_watcher
    @issue, @watcher = IssueWatcher.add_watcher(create_watcher_params)
    respond_to do |format|
      format.js
    end
  end

  def create_watcher_by_admin
    @issue, @watcher = IssueWatcher.add_watcher(create_watcher_params)
    respond_to do |format|
      format.js
    end
  end

  def destroy_watcher
    @issue, @watcher = IssueWatcher.remove_watcher(create_watcher_params)
    respond_to do |format|
      format.js
    end
  end

  def destroy_watcher_by_admin
    @issue, @watcher = IssueWatcher.remove_watcher(create_watcher_params)
    respond_to do |format|
      format.js
    end
  end

  def search_watcher_to_add
    @watchers = IssueWatcher.get_watchers_to_add(search_watcher_params)
    @issue = Issue.find(params[:issue_id])
    respond_to do |format|
      format.js
    end
  end

  def search_watcher_to_destroy
    @watchers = IssueWatcher.get_watchers_to_remove(search_watcher_params)
    @issue = Issue.find(params[:issue_id])
    respond_to do |format|
      format.js
    end
  end

  private

  def create_watcher_params
    params.permit(:issue_id, :watcher_id, :watcher_type)
  end

  def search_watcher_params
    params.permit(:issue_id, :watcher_search, :watcher_type)
  end
end
