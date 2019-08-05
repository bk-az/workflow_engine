# issue_watchers_controller.rb
class IssueWatchersController < ApplicationController
  load_and_authorize_resource
  # POST /issue_watchers/create_watcher
  def create_watcher
    @issue, @watcher = current_tenant.issue_watchers.add_watcher(watcher_params)
    respond_to do |format|
      format.js
    end
  end

  # POST /issue_watchers/destroy_watcher
  def destroy_watcher
    @issue, @watcher = current_tenant.issue_watchers.remove_watcher(watcher_params)
    respond_to do |format|
      format.js
    end
  end

  # GET /issue_watchers/search_watcher_to_add
  def search_watcher_to_add
    @watchers = current_tenant.issue_watchers.get_watchers_to_add(search_watcher_params)
    @issue = current_tenant.issues.find(params[:issue_id])
    respond_to do |format|
      format.js
    end
  end

  # GET /issue_watchers/search_watcher_to_destroy
  def search_watcher_to_destroy
    @watchers = current_tenant.issue_watchers.get_watchers_to_remove(search_watcher_params)
    @issue = current_tenant.issues.find(params[:issue_id])
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
