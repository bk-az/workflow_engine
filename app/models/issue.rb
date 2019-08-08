# Model Class
class Issue < ActiveRecord::Base
  after_save :send_email
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

  has_many   :comments, as: :commentable
  has_many :documents, as: :documentable
  has_many   :comments, as: :commentable, dependent: :destroy

  # Polymorphic Watchers
  has_many   :issue_watchers
  # has_many   :watchers, through: :issue_watchers
  has_many   :watcher_users, through: :issue_watchers, source: :watcher,
                             source_type: 'User', class_name: 'User'
  has_many   :watcher_teams, through: :issue_watchers, source: :watcher,
                             source_type: 'Team', class_name: 'Team'

  PRIORITY = {
    Low: 0,
    Medium: 1,
    High: 2
  }.freeze

  # Helper method for sending email
  def send_email
    return if Rails.env.test?

    emails = []
    issue_watchers.each do |issue_watcher|
      if issue_watcher.watcher.is_a?(User)
        user_email = User.find_by(id: issue_watcher.watcher_id).email
        emails << user_email
      elsif issue_watcher.watcher.is_a?(Team)
        team = Team.find_by(id: issue_watcher.watcher_id)
        team_emails = team.users.pluck(:email)
        emails += team_emails
      end
    end
    # Fetching creator's email
    emails << creator.email

    # Fetching assignee's email
    emails << assignee.email if assignee.present?

    # Removing duplicates and nil values
    emails = emails.compact.uniq
    emails.each do |email|
      IssueMailer.delay.notify(email, id, company_id)
    end
  end
end
