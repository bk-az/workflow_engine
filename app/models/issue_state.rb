class IssueState < ActiveRecord::Base
  validates(:name, presence: true,
                   uniqueness: { scope: [:issue_id, :company_id], case_sensitive: false },
                   length: { minimum: MIN_LENGTH, maximum: MAX_LENGTH_ISSUE_STATE })
  validates :company_id, presence: true

  has_many :issues
  belongs_to :company
  belongs_to :issue

  scope :issue_specific_states, ->(issue_id) { where(issue_id: [issue_id, nil]) }
  scope :issue_states_for_projects, ->(project) { project.issues.map(&:issue_state) }

  def can_change_scope?(issue_id)
    result = true
    if issue_id.present?
      count = issues.where.not(id: issue_id).count
      if count > 0
        result = false
        errors[:base] << "#{count} issue".pluralize(count) +
                         ' found, preventing to change scope' \
                         ' of this issue state'
      end
    end
    result
  end

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
