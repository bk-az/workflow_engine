class IssueState < ActiveRecord::Base
  validates(:name, presence: true,
                   uniqueness: { scope: :company_id, case_sensitive: false },
                   length: { minimum: MIN_LENGTH, maximum: MAX_LENGTH_ISSUE_STATE })
  validates :company_id, presence: true

  has_many :issues
  belongs_to :company
  belongs_to :issue

  scope :issue_states_for_projects, ->(project) { project.issues.map(&:issue_state) }

  def dependent_issues_present?
    result = false
    count = issues.count
    if count > 0
      result = true
      errors[:base] << "#{count} issue".pluralize(count) +
                       ' using this state'
    end
    result
  end
end
