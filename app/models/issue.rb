# Model Class
class Issue < ActiveRecord::Base
  # Kaminari build-in attribute for pagination size per page
  paginates_per 7

  # Validations
  validates :title, presence: true
  validates :description, presence: true
  # validates :start_date, presence: true
  # validates :due_date, presence: true
  # validates :progress, presence: true
  # validates :priority, presence: true

  belongs_to :company
  belongs_to :project
  belongs_to :issue_state
  belongs_to :issue_type

  # An issue belongs to an admin (creator)
  belongs_to :creator, class_name: 'User' # creator

  # An issue can be assigned to a member (assignee)
  belongs_to :assignee, class_name: 'User' # assignee

  # An issue can have many sub issues
  has_many   :sub_issues, foreign_key: 'parent_issue_id', class_name: 'Issue'
  belongs_to :parent_issue, class_name: 'Issue'

  has_many   :documents

  has_many   :comments, as: :commentable

  # Polymorphic Watchers
  has_many   :issue_watchers
  # has_many   :watchers, through: :issue_watchers
  has_many   :watcher_users, through: :issue_watchers, source: :watcher,
                             source_type: 'User', class_name: 'User'
  has_many   :watcher_teams, through: :issue_watchers, source: :watcher,
                             source_type: 'Team', class_name: 'Team'
end
