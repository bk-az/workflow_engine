class Project < ActiveRecord::Base
  has_associated_audits

  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, presence: true, length: { minimum: 3, maximum: 1024 }

  belongs_to :company
  has_many   :issues, dependent: :destroy
  has_many   :issue_types

  has_many :comments, as: :commentable
  has_many :documents, as: :documentable
  has_many :comments, as: :commentable, dependent: :destroy

  # Polymorphic Team/User
  has_many :project_memberships
  # has_many :project_members, through: :project_memberships
  has_many :teams, through: :project_memberships, source: :project_member,
                   source_type: 'Team'
  has_many :users, through: :project_memberships, source: :project_member,
                   source_type: 'User'

  def visible?(user)
    return true if user.admin?
    user.projects.find_by(id: id)
  end

  def has_dependent_issues?
    result = false
    count = issues.count
    if count > 0
      result = true
      errors[:base] << "Unable to delete this project, contains #{count} active issue".pluralize(count)
    end
    result
  end
end
