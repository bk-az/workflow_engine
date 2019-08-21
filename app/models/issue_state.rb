class IssueState < ActiveRecord::Base
  DEFAULT_ISSUE_STATES = %w[Open In-progress Resolved Closed].freeze

  validates(:name, presence: true,
                   uniqueness: { scope: :company_id, case_sensitive: false },
                   length: { minimum: MIN_LENGTH, maximum: MAX_LENGTH_ISSUE_STATE })
  validates :company_id, presence: true

  has_many :issues
  belongs_to :company
  belongs_to :issue

  scope :for_projects, ->(project) { project.issues.map(&:issue_state) }

  def dependent_issues_present?
    issues.count > 0
  end
end
