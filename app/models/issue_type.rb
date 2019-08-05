class IssueType < ActiveRecord::Base
  has_many :issues
  belongs_to :company
  belongs_to :project

  scope :issue_types_for_projects, ->(project) { where(project_id: project.id) }
end
