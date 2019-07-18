class IssueWatcher < ActiveRecord::Base
  belongs_to :watcher, polymorphic: true
  belongs_to :issue
end
