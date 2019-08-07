# Model Class
class Issue < ActiveRecord::Base
  # Kaminari build-in attribute for pagination size per page
  paginates_per 7

  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, length: { minimum: 3, maximum: 500 }
  validates :progress, presence: true, length: { minimum: 1, maximum: 5 }
  validates :priority, presence: true

  belongs_to :company
  belongs_to :project
  belongs_to :issue_state
  has_many   :issue_states
  belongs_to :issue_type

  # An issue belongs to an admin (creator)
  belongs_to :creator, class_name: 'User' # creator

  # An issue can be assigned to a member (assignee)
  belongs_to :assignee, class_name: 'User' # assignee

  # An issue can have many sub issues
  has_many   :sub_issues, foreign_key: 'parent_issue_id', class_name: 'Issue'
  belongs_to :parent_issue, class_name: 'Issue'

  has_many   :documents

  has_many   :comments, as: :commentable, dependent: :destroy

  # Polymorphic Watchers
  has_many   :issue_watchers
  # has_many   :watchers, through: :issue_watchers
  has_many   :watcher_users, through: :issue_watchers, source: :watcher,
                             source_type: 'User'
  has_many   :watcher_teams, through: :issue_watchers, source: :watcher,
                             source_type: 'Team'

  def title_with_project_id
    "P\##{format('%02d', project_id)}: #{title}"
  end

  PRIORITY = {
    Low: 0,
    Medium: 1,
    High: 2
  }.freeze
end
