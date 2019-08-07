require 'faker'

FactoryGirl.define do
  factory :issue_watcher do |f|
    f.issue_id 1
    f.watcher_id 1
    f.watcher_type 'User'
  end
end
