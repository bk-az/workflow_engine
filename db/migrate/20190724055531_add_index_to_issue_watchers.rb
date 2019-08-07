class AddIndexToIssueWatchers < ActiveRecord::Migration
  def change
    add_index :issue_watchers, [:watcher_id, :watcher_type, :issue_id], unique: true
  end
end
