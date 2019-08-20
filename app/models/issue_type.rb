class IssueType < ActiveRecord::Base
  DEFAULT_ISSUE_TYPES = %w[Improvement New\ Feature].freeze

  validates(:name, presence: true,
                   uniqueness: { scope: [:project_id, :company_id], case_sensitive: false },
                   length: { minimum: MIN_LENGTH, maximum: 20 })
  validates :company_id, presence: true

  has_many :issues
  belongs_to :company
  belongs_to :project

  scope :project_issue_types, ->(project_id) { where(project_id: [project_id, nil]) }
  scope :issue_types_for_projects, ->(project) { where(project_id: project.id) }

  def orphan_issues_count(project_id)
    issues.where.not(project_id: project_id).count
  end

  def dependent_issues_present?
    issues.count > 0
  end
end
