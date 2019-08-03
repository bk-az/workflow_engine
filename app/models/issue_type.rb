class IssueType < ActiveRecord::Base
  validates(:name, presence: true,
                   uniqueness: { scope: :company_id, case_sensitive: false },
                   length: { minimum: MIN_LENGTH, maximum: 20 })
  validates :company_id, presence: true

  has_many :issues
  belongs_to :company
  belongs_to :project

  scope :issue_types_for_projects, ->(project) { where(project_id: project.id) }

  def self.safe_update(id, params)
    issue_type = IssueType.find(id)
    if params[:project_id].nil?
      issue_type.update(params)
    else
      count = issue_type.issues.where.not(project_id: params[:project_id]).count
      if count > 0
        issue_type.errors[:base] << "#{count} issue".pluralize(count) +
                                         ' found, preventing to change scope' \
                                         ' of this issue type'
      else
        issue_type.update(params)
      end
    end
    issue_type
  end

  def self.safe_destroy(id)
    issue_type = IssueType.find(id)
    count = issue_type.issues.count
    if count > 0
      issue_type.errors[:base] << "#{count} issue".pluralize(count) +
                                  ' using this type'
    else
      issue_type.destroy
    end
    issue_type
  end

  def self.load_issue_types(project_id)
    if project_id.nil?
      result = IssueType.all
    else
      result = IssueType.where(project_id: [project_id, nil])
    end
    result
  end
end
