class IssueType < ActiveRecord::Base
  validates(:name, presence: true,
                   uniqueness: { scope: [:project_id, :company_id], case_sensitive: false },
                   length: { minimum: MIN_LENGTH, maximum: 20 })
  validates :company_id, presence: true

  has_many :issues
  belongs_to :company
  belongs_to :project

  scope :project_issue_types, ->(project_id) { where(project_id: [project_id, nil]) }
  scope :issue_types_for_projects, ->(project) { where(project_id: project.id) }

  def can_change_scope?(project_id)
    result = true
    if project_id.present?
      count = issues.where.not(project_id: project_id).count
      if count > 0
        result = false
        errors[:base] << "#{count} issue".pluralize(count) +
                         ' found, preventing to change scope' \
                         ' of this issue type'
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
                       ' using this type'
    end
    result
  end
end
