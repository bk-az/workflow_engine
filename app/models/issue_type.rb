class IssueType < ActiveRecord::Base
  validates(:name, presence: true,
                   uniqueness: { scope: :company_id, case_sensitive: false },
                   length: { minimum: MIN_LENGTH, maximum: 20 })
  validates :company_id, presence: true

  has_many :issues
  belongs_to :company
  belongs_to :project

  scope :issue_types_for_projects, ->(project) { where(project_id: project.id) }

  def self.load_issue_types(project_id)
    if project_id.nil?
      result = IssueType.all
    else
      result = IssueType.where(project_id: [project_id, nil])
    end
    result
  end
end
