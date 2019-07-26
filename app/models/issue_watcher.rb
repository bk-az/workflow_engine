class IssueWatcher < ActiveRecord::Base
  not_multitenant

  belongs_to :issue
  belongs_to :watcher, polymorphic: true
end
