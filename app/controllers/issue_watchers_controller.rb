# issue_watchers_controller.rb
class IssueWatchersController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  # POST /issue_watchers/create_watcher
  def create_watcher
    @issue, @watcher = IssueWatcher.add_watcher(watcher_params)
    respond_to do |format|
      format.js
    end
  end

  # POST /issue_watchers/destroy_watcher
  def destroy_watcher
    @issue, @watcher = IssueWatcher.remove_watcher(watcher_params)
    respond_to do |format|
      format.js
    end
  end

  # GET /issue_watchers/search_watcher_to_add
  def search_watcher_to_add
    @watchers = IssueWatcher.get_watchers_to_add(search_watcher_params)
    @issue = current_tenant.issues.find_by(id: params[:issue_id])
    respond_to do |format|
      format.js
    end
  end

  # GET /issue_watchers/search_watcher_to_destroy
  def search_watcher_to_destroy
    @watchers = IssueWatcher.get_watchers_to_remove(search_watcher_params)
    @issue = current_tenant.issues.find_by(id: params[:issue_id])
    respond_to do |format|
      format.js
    end
  end

  private

  # Permits params for CRUD
  def watcher_params
    params.permit(:issue_id, :watcher_id, :watcher_type)
  end

  # Permits params for searching
  def search_watcher_params
    params.permit(:issue_id, :watcher_search, :watcher_type)
  end
end
