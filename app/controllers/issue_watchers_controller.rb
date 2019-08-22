# issue_watchers_controller.rb
class IssueWatchersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  # POST /issue_watchers
  def create
    if @issue_watcher.save
      @issue, @watcher = @issue_watcher.issue, @issue_watcher.watcher
    end
    respond_to do |format|
      format.js
    end
  end

  # DELETE /issue_watchers/:id
  def destroy
    if @issue_watcher.destroy
      @issue, @watcher = @issue_watcher.issue, @issue_watcher.watcher
    end
    respond_to do |format|
      format.js
    end
  end

  # GET /issue_watchers/search
  def search
    @watchers = IssueWatcher.find_watchers(search_watcher_params, current_tenant)
    @issue = current_tenant.issues.find_by(id: params[:issue_id])
    respond_to do |format|
      format.js
    end
  end

  private

  # Permits params for CRUD
  def issue_watcher_params
    params.permit(:issue_id, :watcher_id, :watcher_type)
  end

  # Permits params for searching
  def search_watcher_params
    params.permit(:issue_id, :watcher_search, :watcher_type, :watcher_action)
  end
end
